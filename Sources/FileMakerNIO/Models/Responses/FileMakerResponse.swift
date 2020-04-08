import Foundation

struct FileMakerResponse<T: Codable>: Codable {
    let response: T
    let messages: [ResponseMessage]
}

struct ResponseMessage: Codable {
    let code: String
    let message: String
}
