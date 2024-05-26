import ComposableArchitecture
import SwiftUI

@ViewAction(for: LogsReducer.self)
struct LogsView: View {
	let store: StoreOf<LogsReducer>

	var body: some View {
		NavigationSplitView(
			sidebar: { Text("sidebar") },
			detail: { Text("detail") }
		)
		.onAppear {
			send(.onAppear)
		}
	}
}

#Preview {
	LogsView(
		store: .init(
			initialState: LogsReducer.State(),
			reducer: { LogsReducer() }
		)
	)
}
