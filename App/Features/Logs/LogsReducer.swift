import ComposableArchitecture

@Reducer
struct LogsReducer {
	@ObservableState
	struct State {}

	enum Action {}

	var body: some ReducerOf<Self> {
		Reduce { state, action in
			return .none
		}
	}
}

