import ComposableArchitecture
import SwiftUI

struct MenuBarScene: Scene {
	var store: StoreOf<MenuBarSceneReducer>

	var body: some Scene {
		MenuBarExtra("\(store.remainingTime.toHour() + 1) hour(s) left") {
			MenuBarView(store: store.scope(state: \.menuBar, action: \.menuBar))
				.frame(width: 380)
		}
		.menuBarExtraStyle(.window)
	}
}
