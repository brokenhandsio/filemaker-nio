import NIOHTTP1
import Foundation

struct GetRecordResponse<T: FMIdentifiable>: CodableAction {
    static var method: HTTPMethod {
        .GET
    }
    static var action: String {
        "get record"
    }
    let data: [GetRecordData<T>]
}
