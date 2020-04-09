import Foundation
import NIOHTTP1

public struct EditRecordResponse: CodableAction {
    static let action = "edit record"
    static let method = HTTPMethod.PATCH
    public let modId: String
}
