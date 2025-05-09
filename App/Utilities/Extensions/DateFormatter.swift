import Foundation

extension DateFormatter {
	/// Returns a `DateFormatter` instance configured with the format "MM/dd/yyyy, H:mm:ss a".
	static var standard: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yyyy, H:mm:ss"
		return formatter
	}

	/// Returns a `DateFormatter` instance configured with the format "H:mm".
	static var hourMinute: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "H:mm"
		formatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")!
		return formatter
	}
}

extension FormatStyle where Self == Date.FormatStyle {
	static var standard: Date.FormatStyle {
		return .init()
			.year(.defaultDigits)
			.month(.twoDigits)
			.day(.twoDigits)
			.hour(.defaultDigits(amPM: .omitted))
			.minute(.twoDigits)
			.second(.twoDigits)
	}

	static var hourMinute: Date.FormatStyle {
		return .init()
			.hour(.defaultDigits(amPM: .omitted))
			.minute(.twoDigits)
	}
}

