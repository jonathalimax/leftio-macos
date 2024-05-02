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

	enum Action {
		case animationFinished
	}

	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .animationFinished:
				state.animation = .working
				state.loopMode = .loop
				return .none
			}
		}
	}
}
