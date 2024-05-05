import ComposableArchitecture
import ServiceManagement

public struct AutoStartupService {
	var status: () -> SMAppService.Status
	var turnOn: () throws -> Void
	var turnOff: () throws -> Void
	var openSettings: () -> Void

	static func live(_ appService: SMAppService) -> Self {
		.init(
			status: {
				appService.status
			},
			turnOn: {
				try? appService.register()
				if appService.status == .requiresApproval {
					throw AutoStartupError.denied
				}
			},
			turnOff: {
				try appService.unregister()
			},
			openSettings: {
				SMAppService.openSystemSettingsLoginItems()
			}
		)
	}
}

public enum AutoStartupError: Error {
	case denied
}

private extension String {
	static let autoStartupBundle = "com.lima.jonatha.AutoStartup"
}

import Dependencies

extension AutoStartupService: DependencyKey {
	public static let liveValue: Self = .live(SMAppService.loginItem(identifier: .autoStartupBundle))
	public static var previewValue: Self = .live(SMAppService.loginItem(identifier: .autoStartupBundle))
	public static var testValue: Self = .init(status: { .enabled }, turnOn: {}, turnOff: {}, openSettings: {})
}

extension DependencyValues {
	public var autoStartupService: AutoStartupService {
		get { self[AutoStartupService.self] }
		set { self[AutoStartupService.self] = newValue }
	}
}
