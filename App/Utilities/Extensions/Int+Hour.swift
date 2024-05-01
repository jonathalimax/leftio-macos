extension Int {
	func toHour() -> Int { self / 3600 }

	func toTimer() -> String {
		let hours = self / 3600
		let minutes = (self % 3600) / 60
		let seconds = self % 60
		return "\(hours):\(minutes):\(seconds)"
	}
}
