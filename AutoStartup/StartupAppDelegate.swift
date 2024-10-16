import Cocoa

class StartupAppDelegate: NSObject, NSApplicationDelegate {
	func applicationDidFinishLaunching(_ notification: Notification) {
		startMainApp()
	}

	private func startMainApp() {
		let runningApps = NSWorkspace.shared.runningApplications
		let isRunning = runningApps.contains(where: { $0.bundleIdentifier == "com.lima.leftio" })

		if !isRunning {
			var path = Bundle.main.bundlePath
			print("Running app bundle:", path)

			(1...4).forEach { _ in
				path = (path as NSString).deletingLastPathComponent
				print("After deletingLastPathComponent", path)
			}

			guard let pathURL = URL(string: path as String) else { return }

			print("App path URL", pathURL)

			NSWorkspace.shared.openApplication(
				at: pathURL,
				configuration: NSWorkspace.OpenConfiguration()
			)

		}
	}
}
