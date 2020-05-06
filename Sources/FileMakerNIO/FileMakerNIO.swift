import AsyncHTTPClient
import NIO
import Logging

public class FileMakerNIO {
    let client: Client
    let logger: Logger
    let configuration: FileMakerConfiguration
    
    var token: String?
    
    var apiBaseURL: String {
        "\(configuration.scheme)://\(configuration.hostname):\(configuration.port)/fmi/data/v1/databases/\(configuration.databaseName)/"
    }
    
    public init(configuration: FileMakerConfiguration, client: Client = HTTPClient.init(eventLoopGroupProvider: .createNew), logger: Logger) {
        self.configuration = configuration
        self.client = client
        self.logger = logger
    }
    
    func getToken() throws -> String {
        guard let token = self.token else {
            throw FileMakerNIOError(message: "Token does not exist")
        }
        return token
    }
    
    public func start(on eventLoop: EventLoop) -> EventLoopFuture<Void> {
        let authentication = FilemakerAuthentication(client: self.client, logger: self.logger, configuration: self.configuration, baseURL: self.apiBaseURL)
        return authentication.login(on: eventLoop).map { loginResponse in
            self.token = loginResponse.response.token
        }
    }
    
    public func stop(on eventLoop: EventLoop) -> EventLoopFuture<Void> {
        let authentication = FilemakerAuthentication(client: self.client, logger: self.logger, configuration: self.configuration, baseURL: self.apiBaseURL)
        let token: String
        do {
            token = try getToken()
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
        return authentication.logout(token: token, on: eventLoop)
    }
    
}
