import Foundation
import SwiftData

@Model
class Log {
	var action: Action
	var timestamp: Date

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
