import ComposableArchitecture
import Combine
import SwiftUI
import SwiftData

@main
struct MainApp: App {
	var store: StoreOf<MainAppReducer>

	init() {
		store = .init(initialState: MainAppReducer.State(), reducer: { MainAppReducer() })
		store.send(.initialized)
	}

	var body: some Scene {
		WindowGroup {
			LogsView(
				store: .init(
					initialState: LogsReducer.State(),
					reducer: { LogsReducer() }
				)
			)
		}
		.modelContainer(for: Log.self)

		MenuBarScene()

		Settings {
			SettingsView(
				store: .init(
					initialState: SettingsReducer.State(),
					reducer: { SettingsReducer() }
				)
			)
		}
	}
}
