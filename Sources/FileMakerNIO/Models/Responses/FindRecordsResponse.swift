import NIOHTTP1

public struct FindRecordsResponse<T: Codable>: CodableAction {
    static var method: HTTPMethod {
        .POST
    }
    static var action: String {
        "find records"
    }
    let data: [GetRecordData<T>]
}

