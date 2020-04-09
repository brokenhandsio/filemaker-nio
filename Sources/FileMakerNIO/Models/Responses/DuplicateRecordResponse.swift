import Foundation

public struct DuplicateRecordResponse: CodableAction {
    public static let action = "duplicate record"
    public let recordId: String
    public let modId: String
}
