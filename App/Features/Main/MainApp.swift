import ComposableArchitecture
import Combine
import SwiftUI
import SwiftData

@main
struct MainApp: App {
	@Bindable var store: StoreOf<MainAppReducer>

	init() {
		store = .init(initialState: MainAppReducer.State(), reducer: { MainAppReducer() })
		store.send(.initialized)
	}

	var body: some Scene {
		WindowGroup {
			LogsView(store: store.scope(state: \.logs, action: \.logs))
		}
		.modelContainer(for: Log.self)

		MenuBarScene(remainingTime: store.remainingTime)

		Settings {
			SettingsView(store: store.scope(state: \.settings, action: \.settings))
		}
	}
}
