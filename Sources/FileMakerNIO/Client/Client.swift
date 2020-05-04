import AsyncHTTPClient
import NIO
import NIOHTTP1
import Logging

public protocol Client {
    var eventLoopGroup: EventLoopGroup { get }
    func sendRequest<T: Encodable>(to url: String, method: HTTPMethod, data: T, sessionToken: String?, basicAuth: BasicAuthCredentials?, logger: Logger) -> EventLoopFuture<HTTPClient.Response>
    func sendRequest(to url: String, method: HTTPMethod, sessionToken: String?, logger: Logger) -> EventLoopFuture<HTTPClient.Response>
}

public struct BasicAuthCredentials {
    public let username: String
    public let password: String
}
