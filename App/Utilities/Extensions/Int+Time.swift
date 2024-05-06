import Foundation

extension Int {
	func toTimer(_ components: TimeComponent...) -> String {
		let hours = self / 3600
		let minutes = (self % 3600) / 60
		let seconds = self % 60
		let format = ":%02d"

		var timer: String = ""

		components.forEach {
			switch $0 {
			case .hour: timer.append("\(hours)")
			case .minute: timer.append(.init(format: format, minutes))
			case .second: timer.append(.init(format: format, seconds))
			}
		}

		return timer
	}

	var toDate: Date {
		.init(timeIntervalSinceReferenceDate: TimeInterval(self))
	}
}

extension Int {
	enum TimeComponent: CaseIterable {
		case hour, minute, second
	}

	func converted(from source: TimeComponent, to result: TimeComponent) -> Int {
		switch (source, result) {
		case (.hour, .hour): self
		case (.hour, .minute): self * 60
		case (.hour, .second): self * 3600
		case (.minute, .hour): self / 60
		case (.minute, .minute): self
		case (.minute, .second): self * 60
		case (.second, .hour): self / 3600
		case (.second, .minute): self / 60
		case (.second, .second): self
		}
	}
}
