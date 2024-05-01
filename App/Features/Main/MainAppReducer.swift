import ComposableArchitecture

@Reducer
struct MainAppReducer {
	@Dependency(\.date) private var date
	@Dependency(\.mainQueue) var mainQueue
	@Dependency(\.logService) private var logService
	@Dependency(\.screenStatusService) var screenStatusService

	@ObservableState
	struct State {
		var elapsedTime: Int = .zero
		var workingHours: Int
		var remainingTime: Int

		// MARK: Child states
		var logs: LogsReducer.State
		var settings: SettingsReducer.State

		init(
			workingHours: Int =  8 * 3600, // TODO: Improve it
			logs: LogsReducer.State = .init(),
			settings: SettingsReducer.State = .init()
		) {
			self.workingHours = workingHours
			self.remainingTime = workingHours
			self.logs = logs
			self.settings = settings
		}
	}

	enum Action: BindableAction {
		case initialized
		case timerTicked
		case screenStatusChanged(ScreenStatus)
		case binding(BindingAction<State>)

		// MARK: Child actions
		case logs(LogsReducer.Action)
		case settings(SettingsReducer.Action)
	}

	enum Cancellables {
		case timer
	}

	var body: some ReducerOf<Self> {
		BindingReducer()
		Scope(state: \.logs, action: \.logs) { LogsReducer() }
		Scope(state: \.settings, action: \.settings) { SettingsReducer() }

		Reduce { state, action in
			switch action {
			case .initialized:
				return .merge(
					persistLog(.start),
					listenScreenStatus(),
					fireTimer()
				)

			case .screenStatusChanged(.locked):
				return persistLog(.break)

			case .screenStatusChanged(.unlocked):
				return persistLog(.restart)

			case .timerTicked:
				return onTimerTick(&state)

			case .logs, .settings, .binding:
				return .none
			}
		}
	}

	private func persistLog(_ action: Log.Action) -> EffectOf<Self> {
		.run { _ in try logService.persist(.init(action: action, timestamp: date.now)) }
	}

	private func listenScreenStatus() -> EffectOf<Self> {
		.run { send in
			for await status in screenStatusService.status {
				await send(.screenStatusChanged(status))
			}
		}
	}

	private func fireTimer() -> EffectOf<Self> {
		.run { send in
			for try await _ in mainQueue.timer(interval: .seconds(1)) {
				await send(.timerTicked)
			}
		}
		.cancellable(id: Cancellables.timer)
	}

	private func onTimerTick(_ state: inout State) -> EffectOf<Self> {
		state.elapsedTime += 1
		state.remainingTime = state.workingHours - state.elapsedTime

		guard state.remainingTime > .zero else {
			return .cancel(id: Cancellables.timer)
		}

		return .none
	}
}

