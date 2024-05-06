import ComposableArchitecture
import Lottie

@Reducer
struct MenuBarReducer {
	@ObservableState
	struct State {
		@Shared var remainingTime: Int
		var animation: LottieAsset = .hello
		var loopMode: LottieLoopMode = .playOnce
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
				state.animation = .working
				state.loopMode = .loop
				return .none


			case .binding:
				return .none
			}
		}
	}
}
