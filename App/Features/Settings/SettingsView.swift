import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
	@Environment(\.openURL) var openURL
	@Bindable var store: StoreOf<SettingsReducer>

	var body: some View {
		List {
			Section("Working time") {
				Slider(value: workingTimeBinding, in: store.workingTimeRange) {
					Text("Working time \(Int(store.WorkingTimeHour))")
				}

				Toggle(isOn: $store.launchAtStartup) {
					Text("Launch at login")
				}
				.toggleStyle(.switch)
			}
		}
		.onAppear {
			store.send(.onAppear)
		}
	}
}

private extension SettingsView {
	var workingTimeBinding: Binding<Double> {
		Binding(
			get: { Double(store.WorkingTimeHour) },
			set: { store.send(.setWorkingTime(Int($0))) }
		)
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
