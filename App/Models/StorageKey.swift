import Foundation
import ComposableArchitecture

public enum StorageKey: String {
	case workingHours
	case lastLogTimestamp
}

extension PersistenceReaderKey {
	/// Creates a persistence key that can read and write to an integer user default.
	///
	/// - Parameter key: The key to read and write the value to in the user defaults store.
	/// - Returns: A user defaults persistence key.
	public static func appStorage(_ key: StorageKey) -> Self where Self == AppStorageKey<Int> {
		AppStorageKey(key.rawValue)
	}

	/// Creates a persistence key that can read and write to an integer user default.
	///
	/// - Parameter key: The key to read and write the value to in the user defaults store.
	/// - Returns: A user defaults persistence key.
	public static func appStorage(_ key: StorageKey) -> Self where Self == AppStorageKey<Int?> {
		AppStorageKey(key.rawValue)
	}

	/// Creates a persistence key that can read and write to an integer user default.
	///
	/// - Parameter key: The key to read and write the value to in the user defaults store.
	/// - Returns: A user defaults persistence key.
	public static func appStorage(_ key: StorageKey) -> Self where Self == AppStorageKey<String> {
		AppStorageKey(key.rawValue)
	}

	/// Creates a persistence key that can read and write to an integer user default.
	///
	/// - Parameter key: The key to read and write the value to in the user defaults store.
	/// - Returns: A user defaults persistence key.
	public static func appStorage(_ key: StorageKey) -> Self where Self == AppStorageKey<String?> {
		AppStorageKey(key.rawValue)
	}
}
