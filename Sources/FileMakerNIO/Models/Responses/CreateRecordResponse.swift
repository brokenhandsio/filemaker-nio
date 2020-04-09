import Foundation

public struct CreateRecordResponse: CodableAction {
    public static let action = "create record"
    public let recordId: String
    public let modId: String
}
