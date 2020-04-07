import AsyncHTTPClient
import NIOHTTP1
import NIO

struct HTTPClientRequester: Requester {
    
    let client: HTTPClient
    
    init(eventLoopGroup: EventLoopGroup) {
        self.client = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
    }
    
    func sendRequest(to url: String, method: HTTPMethod) -> EventLoopFuture<HTTPClient.Response> {
        var headers = HTTPHeaders()
        headers.add(name: "content-type", value: "application/json")
        let request: HTTPClient.Request
        do {
            request = try HTTPClient.Request(url: url, method: method, headers: headers)
        } catch {
            return self.client.eventLoopGroup.next().makeFailedFuture(error)
        }
        return client.execute(request: request)
        
    }
}
