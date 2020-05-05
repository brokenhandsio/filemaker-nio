import NIOHTTP1

public struct GetRangeOfRecordsResponse<T: Codable>: CodableAction {
    static var method: HTTPMethod {
        .GET
    }
    static var action: String {
        "get range of records"
    }
    let data: [GetRecordData<T>]
}
