import Foundation

public struct GetRecordData<T: Codable>: Codable {
    let recordId: String
    let modId: String
    let fieldData: T
}
