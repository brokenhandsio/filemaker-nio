import AsyncHTTPClient
import NIOHTTP1
import NIO
import Foundation
import Logging

extension HTTPClient: Client {
    
    public func sendRequest(to url: String, method: HTTPMethod, sessionToken: String?, logger: Logger, eventLoop: EventLoop) -> EventLoopFuture<Response> {
        executeRequest(to: url, method: method, sessionToken: sessionToken, logger: logger, eventLoop: eventLoop)
    }
    
    public func sendRequest<T>(to url: String, method: HTTPMethod, data: T, sessionToken: String?, basicAuth: BasicAuthCredentials?, logger: Logger, eventLoop: EventLoop) -> EventLoopFuture<Response> where T : Encodable {
        let body: Body
        do {
            let bodyData = try JSONEncoder().encodeAsByteBuffer(data, allocator: ByteBufferAllocator())
            let bodyString = String(decoding: bodyData.readableBytesView, as: UTF8.self)
            logger.trace("FILEMAKERNIO - Request will be: \(bodyString)")
            body = Body.byteBuffer(bodyData)
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
        return executeRequest(to: url, method: method, sessionToken: sessionToken, basicAuth: basicAuth, body: body, logger: logger, eventLoop: eventLoop)
    }
    
    func executeRequest(to url: String, method: HTTPMethod, sessionToken: String?, basicAuth: BasicAuthCredentials? = nil, body: Body? = nil, logger: Logger, eventLoop: EventLoop) -> EventLoopFuture<Response> {
        logger.trace("FILEMAKERNIO - will send request to \(url)")
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
            request = try HTTPClient.Request(url: url, method: method, headers: headers, body: body)
            logger.trace("FILEMAKERNIO - Sending request \(request)")
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
        let eventLoopPreference = EventLoopPreference.delegate(on: eventLoop)
        return self.execute(request: request, eventLoop: eventLoopPreference).map { response in
            logger.trace("FILEMAKERNIO - Received response \(response)")
            if let body = response.body {
                let bodyString = String(decoding: body.readableBytesView, as: UTF8.self)
                logger.trace("FILEMAKERNIO - Response body: \(bodyString)")
            }
            return response
        }
    }
}
