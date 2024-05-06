import ComposableArchitecture

@Reducer
struct ReminderReducer {
	@Dependency(\.localNotificationService) var notificationService
	@ObservableState
	struct State {
		@Shared(.inMemory("lastBreak")) var lastBreak: Int = .zero
		@Shared(.appStorage(.workingHours)) var workingHours: Int = .zero
	}

	enum Action {
		case createReminder(remainingTime: Int)
	}

	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .createReminder(let remainingTime):
				return createReminder(remainingTime, state.lastBreak,state.workingHours)
			}
		}
	}

	private func createReminder(_ remainingTime: Int, _ lastBreak: Int, _ workingHours: Int) -> EffectOf<Self> {
		.run { send in
			// TODO: Work the lastBreak

			let data: (title: String, message: String)? = switch remainingTime {
			case workingHours - .tenSeconds:
				("Milestone \(Emoji.flexedBiceps.generatedColor)", "Congrats on another day enriched with experience!")
			case .zero:
				("Fresh Start 🍃", "Embrace each day's potential.")
			case .halfHour:
				("30 minutes remain", "Perfect time to map out tomorrow's journey.")
			case .oneHour:
				("Final Stretch", "One hour left, give it your all!")
			case .twoHour:
				("Stretch Break \(Emoji.stretch.generatedColor)", "Take a moment to it")
			case .fourHour:
				("Breath Break", "Pause for a moment to take a deep breath.")
			default:
				nil
			}

			guard let data else { return }
			try await notificationService.fire(data.title, data.message)
		}
	}
}

private extension Int {
	static let tenSeconds: Self = 10
	static let halfHour: Self = .secondFactor / 2
	static let oneHour: Self = 1 * .secondFactor
	static let twoHour: Self = 2 * .secondFactor
	static let threeHour: Self = 3 * .secondFactor
	static let fourHour: Self = 4 * .secondFactor
	static let fiveHour: Self = 5 * .secondFactor
	static let sixHour: Self = 6 * .secondFactor
	static let sevenHour: Self = 7 * .secondFactor
	static let eightHour: Self = 8 * .secondFactor
	static let nineHour: Self = 9 * .secondFactor
	static let tenHour: Self = 10 * .secondFactor
	static let elevenHour: Self = 11 * .secondFactor
	private static let secondFactor: Self = 3600
}

private extension String {

}


enum Emoji {
	case stretch
	case flexedBiceps

	var generatedColor: String {
		let emoji = switch self {
		case .stretch: ["🙆", "🙆🏻", "🙆🏼", "🙆🏽", "🙆🏾", "🙆🏿"]
		case .flexedBiceps: ["💪", "💪🏻", "💪🏼", "💪🏽", "💪🏾", "💪🏿"]

		}

		return emoji.randomElement() ?? ""
	}
}
