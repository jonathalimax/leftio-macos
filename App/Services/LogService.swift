import Foundation
import Dependencies
import SwiftData

public struct LogService {
	var persist: (Log) throws -> Void
	var fetchAll: () async throws -> [Log]
	var delete: (Log) async throws -> Void

	enum ServiceError: Error {
		case `internal`
	}
}

extension LogService {
	static func live(modelContext: ModelContext) -> Self {
		.init(
			persist: {
				modelContext.insert($0)
			},
			fetchAll: {
				let descriptor = FetchDescriptor<Log>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
				return try modelContext.fetch(descriptor)
			},
			delete: { 
				modelContext.delete($0)
			}
		)
	}
}

extension LogService: DependencyKey {
	@MainActor
	public static var liveValue: Self {
		do {
			let modelContainer = try ModelContainer(for: Log.self)
			return .live(modelContext: modelContainer.mainContext)
		} catch {
			preconditionFailure("There is no model container for the model you specified")
		}
	}

	@MainActor
	public static var previewValue: Self {
		do {
			let modelConfiguration = ModelConfiguration(for: Log.self, isStoredInMemoryOnly: true)
			let modelContainer = try ModelContainer(for: Log.self, configurations: modelConfiguration)
			return .live(modelContext: modelContainer.mainContext)
		} catch {
			preconditionFailure("There is no model container for the model you specified")
		}
	}

	public static var testValue: Self = {
		preconditionFailure("You should implement the testValue for LogService in order to use it")
	}()
}

extension DependencyValues {
	public var logService: LogService {
		get { self[LogService.self] }
		set { self[LogService.self] = newValue }
	}
}
