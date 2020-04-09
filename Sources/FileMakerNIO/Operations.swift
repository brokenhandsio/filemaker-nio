import Foundation
import NIO
import AsyncHTTPClient

public extension FileMakerNIO {
    
    internal func performOperation<T, R>(url: String, data: T, type: R.Type) -> EventLoopFuture<R> where T: Encodable, R: CodableAction {
        let token: String
        do {
            token = try self.getToken()
        } catch {
            return self.client.eventLoopGroup.next().makeFailedFuture(error)
        }
        return self.client.sendRequest(to: url, method: type.method, data: data, sessionToken: token).flatMapThrowing { response in
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
        return self.client.sendRequest(to: url, method: type.method, sessionToken: token).flatMapThrowing { response in
            try self.validateAndGetResponse(response, type: type)
        }
    }
    
    internal func validateAndGetResponse<T>(_ response: HTTPClient.Response, type: T.Type) throws -> T where T: CodableAction {
        guard let body = response.body else {
            throw FileMakerNIOError(message: "The FileMaker response contained no data")
        }
        let fmResponse = try JSONDecoder().decode(FileMakerResponse<T>.self, from: body)
        guard let message = fmResponse.messages.first else {
            throw FileMakerNIOError(message: "Invalid response from FileMaker")
        }
        guard message.code == "0" else {
            throw FileMakerNIOError(message: "Failed to \(type.action). Error code \(message.code): \(message.message)")
        }
        return fmResponse.response
    }
    
    func createRecord<T>(layout: String, data: T) -> EventLoopFuture<CreateRecordResponse> where T: Encodable {
        
        let url = "https://\(self.configuration.hostname)/fmi/data/v1/databases/\(self.configuration.databaseName)/layouts/\(layout)/records"
        return self.performOperation(url: url, data: data, type: CreateRecordResponse.self)
    }
    
    func editRecord<T>(_ id: Int, layout: String, data: T) -> EventLoopFuture<EditRecordResponse> where T: Encodable {
        let url = "https://\(self.configuration.hostname)/fmi/data/v1/databases/\(self.configuration.databaseName)/layouts/\(layout)/records/\(id)"
        return self.performOperation(url: url, data: data, type: EditRecordResponse.self)
    }
    
    func duplicateRecord<T>(_ id: Int, layout: String, data: T) -> EventLoopFuture<DuplicateRecordResponse> where T: Encodable {
        let url = "https://\(self.configuration.hostname)/fmi/data/v1/databases/\(self.configuration.databaseName)/layouts/\(layout)/records/\(id)"
        return self.performOperation(url: url, data: data, type: DuplicateRecordResponse.self)
    }
    
    func deleteRecord(_ id: Int, layout: String) -> EventLoopFuture<Void> {
        let url = "https://\(self.configuration.hostname)/fmi/data/v1/databases/\(self.configuration.databaseName)/layouts/\(layout)/records/\(id)"
        return self.performOperation(url: url, type: DeleteRecordResponse.self).map { _ in }
    }
}
