import ComposableArchitecture

@Reducer
struct SettingsReducer {
	@ObservableState
	struct State {
		var selectedWorkingTime: Double = 8 // TODO: Handle the default time as second
	}

	enum Action: BindableAction {
		case binding(BindingAction<State>)
	}

	var body: some ReducerOf<Self> {
		BindingReducer()
		
		Reduce { state, action in
			return .none
		}
	}
}
