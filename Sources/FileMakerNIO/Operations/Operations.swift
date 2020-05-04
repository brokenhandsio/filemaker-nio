import Foundation
import NIO
import AsyncHTTPClient

extension FileMakerNIO {
    
    internal func performOperation<T, R>(url: String, data: T, type: R.Type) -> EventLoopFuture<R> where T: Encodable, R: CodableAction {
        let token: String
        do {
            token = try self.getToken()
        } catch {
            return self.client.eventLoopGroup.next().makeFailedFuture(error)
        }
        return self.client.sendRequest(to: url, method: type.method, data: data, sessionToken: token, basicAuth: nil, logger: self.logger).flatMapThrowing { response in
            try self.validateAndGetResponse(response, type: type)
        }
    }
    
    internal func performOperation<R>(url: String, type: R.Type) -> EventLoopFuture<R> where R: CodableAction {
        let token: String
        do {
            token = try self.getToken()
        } catch {
            return self.client.eventLoopGroup.next().makeFailedFuture(error)
        }
        return self.client.sendRequest(to: url, method: type.method, sessionToken: token, logger: self.logger).flatMapThrowing { response in
            try self.validateAndGetResponse(response, type: type)
        }
    }
    
    internal func validateAndGetResponse<T>(_ response: HTTPClient.Response, type: T.Type) throws -> T where T: CodableAction {
        guard let body = response.body else {
            throw FileMakerNIOError(message: "The FileMaker response contained no data")
        }
        let fmResponse = try JSONDecoder().decode(FileMakerResponse<EmptyRequest>.self, from: body)
        guard let message = fmResponse.messages.first else {
            throw FileMakerNIOError(message: "Invalid response from FileMaker")
        }
        guard message.code == "0" else {
            self.logger.error("FILEMAKERNIO - received error code \(message.code) from FileMaker with message \(message.message)")
            let filemakerError = FileMakerError(errorCode: message.code, message: message.message)
            throw filemakerError
        }
        let realResponse = try JSONDecoder().decode(FileMakerResponse<T>.self, from: body)
        return realResponse.response
    }
}
