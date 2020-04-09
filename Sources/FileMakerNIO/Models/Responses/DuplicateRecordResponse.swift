import Foundation
import NIOHTTP1

public struct DuplicateRecordResponse: CodableAction {
    static let action = "duplicate record"
    static let method = HTTPMethod.POST
    public let recordId: String
    public let modId: String
}
