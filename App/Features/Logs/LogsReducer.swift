import ComposableArchitecture

@Reducer
struct LogsReducer {
	@ObservableState
	struct State {}

	enum Action {}

	var body: some ReducerOf<Self> {
		EmptyReducer()
	}
}

