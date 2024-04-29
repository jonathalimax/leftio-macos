import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
	@Bindable var store: StoreOf<SettingsReducer>

	var body: some View {
		List {
			Section("Working time") {
				Slider(value: $store.selectedWorkingTime, in: 1...12) {
					Text("Working time \(Int(store.selectedWorkingTime))")
				}

				Toggle(isOn: .constant(true)) {
					Text("Launch at login")
				}
				.toggleStyle(.switch)
			}
		}
	}
}

#Preview {
	SettingsView(
		store: .init(
			initialState: SettingsReducer.State(),
			reducer: { SettingsReducer() }
		)
	)
	.frame(width: 300, height: 300)
}
