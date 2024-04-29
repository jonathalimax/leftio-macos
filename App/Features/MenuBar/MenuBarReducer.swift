import Lottie
import ComposableArchitecture

@Reducer
struct MenuBarReducer {
	@ObservableState
	struct State {
		var animation: LottieAsset = .hello
		var loopMode: LottieLoopMode = .playOnce
	}

	enum Action {
		case onAppear
		case animationFinished
	}

	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .onAppear:
				return .none

			case .animationFinished:
				state.animation = .working
				state.loopMode = .loop
				return .none
			}
		}
	}
}
