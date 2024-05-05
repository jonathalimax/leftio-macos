import ComposableArchitecture
import Foundation

@Reducer
struct MainAppReducer {
	@Dependency(\.date) private var date
	@Dependency(\.calendar) private var calendar
	@Dependency(\.mainQueue) var mainQueue
	@Dependency(\.logService) private var logService
	@Dependency(\.autoStartupService) var autoStartupService
	@Dependency(\.screenStatusService) var screenStatusService

	@ObservableState
	struct State {
		@Shared(.appStorage(.lastLogTimestamp)) var lastLogTimestamp: String?
		@Shared(.appStorage(.launchAtStartup)) var launchAtStartup: Bool?
		@Shared(.appStorage(.workingHours)) var workingHours: Int = .defaultWorkingHour
		@Shared var remainingTime: Int
		var elapsedTime: Int = .zero

		// MARK: Child states
		var logs: LogsReducer.State = .init()
		var menuBar: MenuBarSceneReducer.State
		var settings: SettingsReducer.State = .init()

		init() {
			self._remainingTime = Shared(.defaultWorkingHour)
			self.menuBar = .init(remainingTime: Shared(.defaultWorkingHour))
		}
	}

	enum Action: BindableAction {
		case initialized
		case timerTicked
		case screenStatusChanged(ScreenStatus)
		case binding(BindingAction<State>)

		// MARK: Child actions
		case logs(LogsReducer.Action)
		case menuBar(MenuBarSceneReducer.Action)
		case settings(SettingsReducer.Action)
	}

	enum Cancellables {
		case timer
	}

	var body: some ReducerOf<Self> {
		BindingReducer()
		Scope(state: \.logs, action: \.logs) { LogsReducer() }
		Scope(state: \.menuBar, action: \.menuBar) { MenuBarSceneReducer() }
		Scope(state: \.settings, action: \.settings) { SettingsReducer() }

		Reduce { state, action in
			switch action {
			case .initialized:
				return initialize(&state)

			case .screenStatusChanged(.locked):
				return .merge(
					persistLog(.break),
					.cancel(id: Cancellables.timer)
				)

			case .screenStatusChanged(.unlocked):
				return .merge(
					persistLog(.restart),
					fireTimer(&state)
				)

			case .timerTicked:
				return onTimerTick(&state)

			case .binding, .logs, .menuBar, .settings:
				return .none
			}
		}
	}

	private func initialize(_ state: inout State) -> EffectOf<Self> {
		state.menuBar = .init(remainingTime: state.$remainingTime)

		return .merge(
			persistLog(.start),
			listenScreenStatus(),
			fireTimer(&state),
			enableAutoStartup(state)
		)
	}

	private func persistLog(_ action: Log.Action) -> EffectOf<Self> {
		.run { send in try logService.persist(.init(action: action, timestamp: date.now)) }
	}

	private func listenScreenStatus() -> EffectOf<Self> {
		.run { send in
			for await status in screenStatusService.status {
				await send(.screenStatusChanged(status))
			}
		}
	}

	private func fireTimer(_ state: inout State) -> EffectOf<Self> {
		if isStartingNewDay(state.lastLogTimestamp) {
			return startNewDay(&state)
		}

		state.lastLogTimestamp = date.now.formatted(.standard)

		return .run { send in
			for try await _ in mainQueue.timer(interval: .seconds(1)) {
				await send(.timerTicked)
			}
		}
		.cancellable(id: Cancellables.timer)
	}

	private func onTimerTick(_ state: inout State) -> EffectOf<Self> {
		state.elapsedTime += 1
		state.remainingTime = state.workingHours - state.elapsedTime

		if isStartingNewDay(state.lastLogTimestamp) {
			return startNewDay(&state)
		}

		guard state.remainingTime > .zero else {
			return .cancel(id: Cancellables.timer)
		}

		return .none
	}

	private func isStartingNewDay(_ lastLogTimestamp: String?) -> Bool {
		guard let lastLogTimestamp, let lastLogDate = DateFormatter.standard.date(from: lastLogTimestamp) else {
			return false
		}

		return calendar.compare(date.now, to: lastLogDate, toGranularity: .day) == .orderedDescending
	}

	private func startNewDay(_ state: inout State) -> EffectOf<Self> {
		state.lastLogTimestamp = date.now.formatted(.standard)
		state = .init()
		return initialize(&state)
	}

	private func enableAutoStartup(_ state: State) -> EffectOf<Self> {
		.run { [launchAtStartup = state.launchAtStartup] _ in
			if launchAtStartup == nil, autoStartupService.status() == .notRegistered {
				try? autoStartupService.turnOn()
			}
		}
	}
}

private extension Int {
	static let defaultWorkingHour: Self = Time.convert(.hour(8), to: .second)
}
