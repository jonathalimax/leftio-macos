import ComposableArchitecture

@Reducer
struct MainAppReducer {
	@Dependency(\.date) private var date
	@Dependency(\.mainQueue) var mainQueue
	@Dependency(\.logService) private var logService
	@Dependency(\.screenStatusService) var screenStatusService

	@ObservableState
	struct State {
		var logs: LogsReducer.State = .init()
		var settings: SettingsReducer.State = .init()
	}

	enum Action {
		case initialized
		case screenStatusChanged(ScreenStatus)

		case logs(LogsReducer.Action)
		case settings(SettingsReducer.Action)
	}

	var body: some ReducerOf<Self> {
		Scope(state: \.logs, action: \.logs) { LogsReducer() }
		Scope(state: \.settings, action: \.settings) { SettingsReducer() }

		Reduce { state, action in
			switch action {
			case .initialized:
				return .merge(
					persistLog(.start),
					listenScreenStatus()
				)

			case .screenStatusChanged(.locked):
				return persistLog(.break)

			case .screenStatusChanged(.unlocked):
				return persistLog(.restart)

			case .logs, .settings:
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
}

