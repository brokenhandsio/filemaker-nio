import Foundation

public struct EditRecordResponse: CodableAction {
    public static let action = "edit record"
    public let modId: String
}
