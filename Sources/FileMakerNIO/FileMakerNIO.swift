import AsyncHTTPClient
import NIO

public class FileMakerNIO {
    let client: Client
    let configuration: FileMakerConfiguration
    
    var token: String?
    
    public init(configuration: FileMakerConfiguration, client: Client = HTTPClient.init(eventLoopGroupProvider: .createNew)) {
        self.configuration = configuration
        self.client = client
    }
    
    func getToken() throws -> String {
        guard let token = self.token else {
            throw FileMakerNIOError(message: "Token does not exist")
        }
        return token
    }
    
    func start() -> EventLoopFuture<Void> {
        let authentication = FilemakerAuthentication(client: self.client, configuration: self.configuration)
        return authentication.login().map { loginResponse in
            self.token = loginResponse.response.token
        }
    }
    
    func stop() -> EventLoopFuture<Void> {
        let authentication = FilemakerAuthentication(client: self.client, configuration: self.configuration)
        let token: String
        do {
            token = try getToken()
        } catch {
            return self.client.eventLoopGroup.next().makeFailedFuture(error)
        }
        return authentication.logout(token: token)
    }
    
}
