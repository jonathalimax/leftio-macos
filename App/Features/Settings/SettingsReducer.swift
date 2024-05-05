import ComposableArchitecture

@Reducer
struct SettingsReducer {
	@Dependency(\.autoStartupService) var autoStartupService

	@ObservableState
	struct State {
		@Shared(.appStorage(.workingHours)) var workingTime: Int = .standardWorkingTime
		var launchAtStartup: Bool = false

		var workingTimeRange: ClosedRange<Double> = 1...12

		var WorkingTimeHour: Int {
			workingTime.converted(from: .second, to: .hour)
		}
	}

	enum Action: BindableAction {
		case onAppear
		case setWorkingTime(Int)
		case launchAtStartupStatsFetched(_ enabled: Bool)

		case binding(BindingAction<State>)
	}

	var body: some ReducerOf<Self> {
		BindingReducer()

		Reduce { state, action in
			switch action {
			case .onAppear:
				return fetchLaunchAtLoginStatus()

			case .setWorkingTime(let time):
				state.workingTime = time.converted(from: .hour, to: .second)
				return .none

			case .launchAtStartupStatsFetched(let enabled):
				state.launchAtStartup = enabled
				return .none

			case .binding(\.launchAtStartup):
				return .run { [launchAtStartup = state.launchAtStartup]_ in
					switch launchAtStartup {
					case true: try autoStartupService.turnOn()
					case false: try autoStartupService.turnOff()
					}
				} catch: { error, send in
					if (error as? AutoStartupError) == .denied {
						autoStartupService.openSettings()
					}
				}

			case .binding:
				return .none
			}
		}
	}

	private func fetchLaunchAtLoginStatus() -> EffectOf<Self> {
		.run { send in await send(.launchAtStartupStatsFetched(autoStartupService.status() == .enabled)) }
	}
}

private extension Int {
	static let standardWorkingTime: Self = 8
}
