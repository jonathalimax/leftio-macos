import Foundation
import ComposableArchitecture

public enum StorageKey: String {
	case workingHours
	case lastLogTimestamp
	case launchAtStartup
}

extension PersistenceReaderKey {
	/// Creates a persistence key that can read and write to an integer user default.
	///
	/// - Parameter key: The key to read and write the value to in the user defaults store.
	/// - Returns: A user defaults persistence key.
	public static func appStorage(_ key: StorageKey) -> Self where Self == AppStorageKey<Int> {
		AppStorageKey(key.rawValue)
	}

	/// Creates a persistence key that can read and write to an optional integer user default.
	///
	/// - Parameter key: The key to read and write the value to in the user defaults store.
	/// - Returns: A user defaults persistence key.
	public static func appStorage(_ key: StorageKey) -> Self where Self == AppStorageKey<Int?> {
		AppStorageKey(key.rawValue)
	}

	/// Creates a persistence key that can read and write to an string user default.
	///
	/// - Parameter key: The key to read and write the value to in the user defaults store.
	/// - Returns: A user defaults persistence key.
	public static func appStorage(_ key: StorageKey) -> Self where Self == AppStorageKey<String> {
		AppStorageKey(key.rawValue)
	}

	/// Creates a persistence key that can read and write to an optional string user default.
	///
	/// - Parameter key: The key to read and write the value to in the user defaults store.
	/// - Returns: A user defaults persistence key.
	public static func appStorage(_ key: StorageKey) -> Self where Self == AppStorageKey<String?> {
		AppStorageKey(key.rawValue)
	}

	/// Creates a persistence key that can read and write to a boolean user default.
	///
	/// - Parameter key: The key to read and write the value to in the user defaults store.
	/// - Returns: A user defaults persistence key.
	public static func appStorage(_ key: StorageKey) -> Self where Self == AppStorageKey<Bool> {
		AppStorageKey(key.rawValue)
	}

	/// Creates a persistence key that can read and write to a optional boolean user default.
	///
	/// - Parameter key: The key to read and write the value to in the user defaults store.
	/// - Returns: A user defaults persistence key.
	public static func appStorage(_ key: StorageKey) -> Self where Self == AppStorageKey<Bool?> {
		AppStorageKey(key.rawValue)
	}
	
	/// Creates a persistence key that can read and write to a double user default.
	///
	/// - Parameter key: The key to read and write the value to in the user defaults store.
	/// - Returns: A user defaults persistence key.
	public static func appStorage(_ key: StorageKey) -> Self where Self == AppStorageKey<Double> {
		AppStorageKey(key.rawValue)
	}

	/// Creates a persistence key that can read and write to a optional double user default.
	///
	/// - Parameter key: The key to read and write the value to in the user defaults store.
	/// - Returns: A user defaults persistence key.
	public static func appStorage(_ key: StorageKey) -> Self where Self == AppStorageKey<Double?> {
		AppStorageKey(key.rawValue)
	}
}
