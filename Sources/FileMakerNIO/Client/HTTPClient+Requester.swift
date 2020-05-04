import AsyncHTTPClient
import NIOHTTP1
import NIO
import Foundation
import Logging

extension HTTPClient: Client {
    
    public func sendRequest(to url: String, method: HTTPMethod, sessionToken: String?, logger: Logger) -> EventLoopFuture<Response> {
        var headers = HTTPHeaders()
        headers.add(name: "content-type", value: "application/json")
        if let token = sessionToken {
            headers.add(name: "authorization", value: "Bearer \(token)")
        }
        let request: HTTPClient.Request
        do {
            request = try HTTPClient.Request(url: url, method: method, headers: headers)
        } catch {
            return self.eventLoopGroup.next().makeFailedFuture(error)
        }
        return self.execute(request: request)
    }
    
    public func sendRequest<T>(to url: String, method: HTTPMethod, data: T, sessionToken: String?, basicAuth: BasicAuthCredentials?, logger: Logger) -> EventLoopFuture<Response> where T : Encodable {
        var headers = HTTPHeaders()
        headers.add(name: "content-type", value: "application/json")
        if let token = sessionToken {
            headers.add(name: "authorization", value: "Bearer \(token)")
        }
        if let basicAuth = basicAuth {
            let authString = "\(basicAuth.username):\(basicAuth.password)"
            let encoded = Data(authString.utf8).base64EncodedString()
            headers.add(name: "authorization", value: "Basic \(encoded)")
        }
        let request: HTTPClient.Request
        do {
            let body = try JSONEncoder().encodeAsByteBuffer(data, allocator: ByteBufferAllocator())
            request = try HTTPClient.Request(url: url, method: method, headers: headers, body: Body.byteBuffer(body))
            logger.trace("FILEMAKERNIO - Sending request \(request)")
        } catch {
            return self.eventLoopGroup.next().makeFailedFuture(error)
        }
        return self.execute(request: request).map { response in
            logger.trace("FILEMAKERNIO - Received response \(response)")
            if let body = response.body {
                let bodyString = String(decoding: body.readableBytesView, as: UTF8.self)
                logger.error("FILEMAKERNIO - Response body: \(bodyString)")
            }
            return response
        }
    }
}
