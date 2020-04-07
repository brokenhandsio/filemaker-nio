import NIO
import Foundation

struct FilemakerAuthentication {
    
    let requester: Requester
    let configuration: FileMakerConfiguration
    
    func login(on eventLoop: EventLoop) -> EventLoopFuture<LoginResponse> {
        let url = "https://\(configuration.hostname)/fmi/data/v1/databases/\(configuration.databaseName)/sessions"
        return requester.sendRequest(to: url, method: .POST).flatMapThrowing { response in
            guard response.status == .ok else {
                if response.status == .unauthorized {
                    throw FileMakerError(message: "The username or password was incorrect")
                } else {
                    throw FileMakerError(message: "There was an error logging in")
                }
            }
            guard let body = response.body else {
                throw FileMakerError(message: "The login response contained no data")
            }
            let response = try JSONDecoder().decode(LoginResponse.self, from: body)
            return response
        }
    }
    
    func logout(on eventLoop: EventLoop, with token: String) -> EventLoopFuture<Void> {
        let url = "https://\(configuration.hostname)/fmi/data/v1/databases/\(configuration.databaseName)/sessions/\(token)"
        return requester.sendRequest(to: url, method: .DELETE).flatMapThrowing { response in
            guard response.status == .ok else {
                throw FileMakerError(message: "Failed to log out of database")
            }
        }
    }
}
