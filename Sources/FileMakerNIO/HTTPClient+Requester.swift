import AsyncHTTPClient
import NIOHTTP1
import NIO

extension HTTPClient: Requester {
    func sendRequest(to url: String, method: HTTPMethod) -> EventLoopFuture<Response> {
        var headers = HTTPHeaders()
        headers.add(name: "content-type", value: "application/json")
        let request: HTTPClient.Request
        do {
            request = try HTTPClient.Request(url: url, method: method, headers: headers)
        } catch {
            return self.eventLoopGroup.next().makeFailedFuture(error)
        }
        return self.execute(request: request)
    }    
}
