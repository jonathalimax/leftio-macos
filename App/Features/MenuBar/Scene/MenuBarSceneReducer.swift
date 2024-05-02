import Lottie
import ComposableArchitecture

@Reducer
struct MenuBarSceneReducer {
	@ObservableState
	struct State {
		@Shared var remainingTime: Int

		// MARK: Child states
		var menuBar: MenuBarReducer.State

		init(remainingTime: Shared<Int>) {
			self._remainingTime = remainingTime
			menuBar = .init(remainingTime: remainingTime)
		}
	}

	enum Action {
		case menuBar(MenuBarReducer.Action)
	}

	var body: some ReducerOf<Self> {
		Scope(state: \.menuBar, action: \.menuBar) { MenuBarReducer() }
	}
}
