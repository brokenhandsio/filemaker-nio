import Foundation
import NIOHTTP1

public struct CreateRecordResponse: CodableAction {
    static let action = "create record"
    static let method = HTTPMethod.POST
    public let recordId: String
    public let modId: String
}
