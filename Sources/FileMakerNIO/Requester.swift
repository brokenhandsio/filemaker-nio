import AsyncHTTPClient
import NIO
import NIOHTTP1

protocol Requester {
    func sendRequest(to url: String, method: HTTPMethod) -> EventLoopFuture<HTTPClient.Response>
}
