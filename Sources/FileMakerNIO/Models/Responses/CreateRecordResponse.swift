import Foundation

struct CreateRecordResponseContainer: Codable {
    let response:  CreateRecordResponse
}

public struct CreateRecordResponse: Codable {
    let recordId: String
    let modId: String
}
