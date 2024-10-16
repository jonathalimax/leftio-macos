import Foundation

public struct EquatableAction<ActionReturn> : Equatable {
	let id: UUID
	let action: () -> ActionReturn

	public static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
}
