import Foundation

struct LoginResponse: Codable {
    let response: LoginResponseToken
}

struct LoginResponseToken: Codable {
    let token: String
}
