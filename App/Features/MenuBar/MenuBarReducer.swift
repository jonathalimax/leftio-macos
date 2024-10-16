import ComposableArchitecture
import Lottie

@Reducer
struct MenuBarReducer {
	@ObservableState
	struct State {
		@Shared var remainingTime: Int
	}

	enum Action: BindableAction {
		case animationFinished
		case binding(BindingAction<State>)
	}

	var body: some ReducerOf<Self> {
		BindingReducer()

		Reduce { state, action in
			switch action {
			case .animationFinished:
				return .none

			case .binding:
				return .none
			}
		}
	}
}
