import Foundation

extension DateFormatter {
	/// Returns a `DateFormatter` instance configured with the format "MM/dd/yyyy, h:mm:ss a".
	static var standard: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yyyy, H:mm:ss"
		return formatter
	}
}

extension FormatStyle where Self == Date.FormatStyle {
	static var standard: Date.FormatStyle {
		.init()
		.year(.defaultDigits)
		.month(.twoDigits)
		.day(.twoDigits)
		.hour(.defaultDigits(amPM: .omitted))
		.minute(.twoDigits)
		.second(.twoDigits)
	}
}

