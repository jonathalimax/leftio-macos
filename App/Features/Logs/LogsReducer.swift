import ComposableArchitecture

@Reducer
struct LogsReducer {
	@Dependency(\.logService) private var logService

	@ObservableState
	struct State {
		var logs: [Log] = []
	}

	enum Action: ViewAction, Equatable {
		enum ViewAction: Equatable {
			case onAppear
		}

		case fetchLogs
		case logsFetched([Log])

		case view(ViewAction)
		case delegate(Never)
	}

	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .view(.onAppear):
				return .none

			case .fetchLogs:
				return .run { send in
					let logs = try await logService.fetchAll()
					await send(.logsFetched(logs))
				}

			case .logsFetched(let logs):
				state.logs = logs
				return .none
			}
		}
	}
}

