import NIO
import Foundation

struct FilemakerAuthentication {
    
    let client: Client
    let configuration: FileMakerConfiguration
    
    func login() -> EventLoopFuture<LoginResponse> {
        let url = "https://\(configuration.hostname)/fmi/data/v1/databases/\(configuration.databaseName)/sessions"
        return client.sendRequest(to: url, method: .POST, sessionToken: nil).flatMapThrowing { response in
            guard response.status == .ok else {
                if response.status == .unauthorized {
                    throw FileMakerNIOError(message: "The username or password was incorrect")
                } else {
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
        let url = "https://\(configuration.hostname)/fmi/data/v1/databases/\(configuration.databaseName)/sessions/\(token)"
        return client.sendRequest(to: url, method: .DELETE, sessionToken: nil).flatMapThrowing { response in
            guard response.status == .ok else {
                throw FileMakerNIOError(message: "Failed to log out of database")
            }
        }
    }
}
