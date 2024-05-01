import ComposableArchitecture
import Lottie
import SwiftUI

struct MenuBarScene: Scene {
	var remainingTime: Int

	init(remainingTime: Int) {
		self.remainingTime = remainingTime
//		print(remainingTime)
	}

	var body: some Scene {
		MenuBarExtra("\(remainingTime.toHour()) hour(s) left") {
			MenuBarView(
				store: .init(
					initialState: MenuBarReducer.State(remainingTime: remainingTime), // TODO: FIX
					reducer: { MenuBarReducer() }
				)
			)
		}
		.menuBarExtraStyle(.window)
	}
}

struct MenuBarView: View {
	let store: StoreOf<MenuBarReducer>

	var body: some View {
		VStack(alignment: .leading, spacing: .zero) {
			Text("\(store.remainingTime.toTimer()) left")
				.font(.system(.largeTitle))

			LottieView(animation: .named(store.animation))
				.playing(loopMode: store.loopMode)
				.animationDidFinish { _ in store.send(.animationFinished) }
				.frame(width: 300, height: 300)
				.aspectRatio(contentMode: .fit)
		}
		.padding([.horizontal, .top])
		.onAppear {
			store.send(.onAppear)
		}
	}
}

#Preview {
	MenuBarView(
		store: .init(
			initialState: MenuBarReducer.State(remainingTime: 3600),
			reducer: { MenuBarReducer() }
		)
	)
}
