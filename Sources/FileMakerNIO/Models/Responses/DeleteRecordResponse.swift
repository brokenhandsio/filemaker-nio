import NIOHTTP1

public struct DeleteRecordResponse: CodableAction {
    static let action = "delete record"
    static let method = HTTPMethod.DELETE
}
