import NIO
import Foundation
import Logging

struct FilemakerAuthentication {
    
    let client: Client
    let logger: Logger
    let configuration: FileMakerConfiguration
    let baseURL: String
    
    struct EmptyBody: Codable {
        
    }
    
    func login() -> EventLoopFuture<LoginResponse> {
        let url = "\(baseURL)sessions"
        logger.trace("FILEMAKERNIO - attempting login to \(url)")
        return client.sendRequest(to: url, method: .POST, data: EmptyBody(), sessionToken: nil, logger: self.logger).flatMapThrowing { response in
            self.logger.trace("FILEMAKERNIO - Received login response \(response)")
            guard response.status == .ok else {
                if response.status == .unauthorized {
                    throw FileMakerNIOError(message: "The username or password was incorrect")
                } else {
                    if let body = response.body {
                        let bodyString = String(decoding: body.readableBytesView, as: UTF8.self)
                        self.logger.error("Response body: \(bodyString)")
                    }
                    
                    throw FileMakerNIOError(message: "There was an error logging in")
                }
            }
            guard let body = response.body else {
                throw FileMakerNIOError(message: "The login response contained no data")
            }
            let response = try JSONDecoder().decode(LoginResponse.self, from: body)
            return response
        }
    }
    
    func logout(token: String) -> EventLoopFuture<Void> {
        let url = "\(baseURL)sessions/\(token)"
        return client.sendRequest(to: url, method: .DELETE, sessionToken: nil).flatMapThrowing { response in
            guard response.status == .ok else {
                throw FileMakerNIOError(message: "Failed to log out of database")
            }
        }
    }
}
