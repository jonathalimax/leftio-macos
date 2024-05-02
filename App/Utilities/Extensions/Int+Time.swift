extension Int {
	func toHour() -> Int { self / 3600 }

	func toTimer() -> String {
		let hours = self / 3600
		let minutes = (self % 3600) / 60
		let seconds = self % 60
		return "\(hours):\(minutes):\(seconds)"
	}
}

enum Time {
	enum Component {
		case hour(Int), minute(Int), second(Int)
	}

	enum Result {
		case hour, minute, second
	}

	static func convert(_ source: Component, to result: Result) -> Int {
		switch (source, result) {
		case (.hour(let value), .hour): value
		case (.hour(let value), .minute): value * 60
		case (.hour(let value), .second): value * 3600
		case (.minute(let value), .hour): value / 60
		case (.minute(let value), .minute): value
		case (.minute(let value), .second): value * 60
		case (.second(let value), .hour): value / 3600
		case (.second(let value), .minute): value / 60
		case (.second(let value), .second): value
		}
	}
}
