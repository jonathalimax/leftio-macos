import Dependencies
import UserNotifications

public struct LocalNotificationService {
	public internal(set) var requestAuthorization: () async throws -> Void
	public internal(set) var fire: (_ title: String, _ body: String) async throws -> Void

	static func live(_ notificationCenter: UNUserNotificationCenter = .current(), uuid: UUIDGenerator = .init { UUID() }) -> Self {
		.init(
			requestAuthorization: {
				try await LocalNotificationService.requestAuthorization(notificationCenter)
			},
			fire: { title, body in
				let content = UNMutableNotificationContent()
				content.title = title
				content.body = body
				content.sound = .default

				let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
				let request = UNNotificationRequest(identifier: uuid().uuidString, content: content, trigger: trigger)

				try await LocalNotificationService.requestAuthorization(notificationCenter)
				try await notificationCenter.add(request)
			}
		)
	}

	static func mock() -> Self {
		.init(requestAuthorization: {}, fire: { _, _ in })
	}

	private static func requestAuthorization(_ notificationCenter: UNUserNotificationCenter) async throws -> Void {
		try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
	}
}

extension LocalNotificationService: DependencyKey {
	public static var liveValue: LocalNotificationService = .live()
	public static var previewValue: LocalNotificationService = .mock()
	public static var testValue: LocalNotificationService = .mock()
}

public extension DependencyValues {
	var localNotificationService: LocalNotificationService {
		get { self[LocalNotificationService.self] }
		set { self[LocalNotificationService.self] = newValue }
	}
}
