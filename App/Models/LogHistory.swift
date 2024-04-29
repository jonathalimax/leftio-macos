import Foundation
import SwiftData

@Model
class Log {
	let action: Action
	let timestamp: Date

	init(action: Action, timestamp: Date) {
		self.action = action
		self.timestamp = timestamp
	}
}

extension Log {
	enum Action: Codable {
		case start, `break`, restart, stop
	}
}
