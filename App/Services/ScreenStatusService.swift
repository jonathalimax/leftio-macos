import Combine
import Dependencies
import Foundation

public struct ScreenStatusService {
	let status: AsyncStream<ScreenStatus>

	public init(_ notificationCenter: DistributedNotificationCenter = .default()) {
		self.status = AsyncStream { continuation in
			notificationCenter.addObserver(forName: .lockedScreen, object: nil, queue: nil) { _ in
				continuation.yield(with: .success(.locked))
			}

			notificationCenter.addObserver(forName: .unlockedScreen, object: nil, queue: nil) { _ in
				continuation.yield(with: .success(.unlocked))
			}
		}
	}
}

enum ScreenStatus {
	case locked, unlocked
}

private extension Notification.Name {
	static let lockedScreen: Self = .init("com.apple.screenIsLocked")
	static let unlockedScreen: Self = .init("com.apple.screenIsUnlocked")
}

extension ScreenStatusService: DependencyKey {
	public static var liveValue: Self = .init()
	public static var previewValue: Self = .init()
	public static var testValue: Self = {
		preconditionFailure("You should implement the testValue")
	}()
}

extension DependencyValues {
	public var screenStatusService: ScreenStatusService {
		get { self[ScreenStatusService.self] }
		set { self[ScreenStatusService.self] = newValue }
	}
}
