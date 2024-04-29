import ComposableArchitecture
import SwiftUI

struct LogsView: View {
	let store: StoreOf<LogsReducer>

	var body: some View {
		NavigationSplitView(
			sidebar: { Text("sidebar") },
			detail: { Text("detail") }
		)
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
