import Foundation
import NIO
import AsyncHTTPClient

public extension FileMakerNIO {
    
    func performOperation<T>(url: String, data: T) -> EventLoopFuture<HTTPClient.Response> where T: Encodable {
        let token: String
        do {
            token = try self.getToken()
        } catch {
            return self.client.eventLoopGroup.next().makeFailedFuture(error)
        }
        return self.client.sendRequest(to: url, method: .POST, data: data, sessionToken: token)
    }
    
    func validateAndGetResponse<T>(_ response: HTTPClient.Response, type: T.Type, action: String) throws -> T where T: Codable {
        guard let body = response.body else {
            throw FileMakerNIOError(message: "The FileMaker response contained no data")
        }
        let fmResponse = try JSONDecoder().decode(FileMakerResponse<T>.self, from: body)
        guard let message = fmResponse.messages.first else {
            throw FileMakerNIOError(message: "Invalid response from FileMaker")
        }
        guard message.code == "0" else {
            throw FileMakerNIOError(message: "Failed to \(action). Error code \(message.code): \(message.message)")
        }
        return fmResponse.response
    }
    
    func createRecord<T>(layout: String, data: T) -> EventLoopFuture<CreateRecordResponse> where T: Encodable {
        
        let url = "https://\(self.configuration.hostname)/fmi/data/v1/databases/\(self.configuration.databaseName)/layouts/\(layout)/records"
        return self.performOperation(url: url, data: data).flatMapThrowing { response in
            return try self.validateAndGetResponse(response, type: CreateRecordResponse.self, action: "create record")
        }
    }
    
    func editRecord<T>(_ id: Int, layout: String, data: T, modID: Int?) -> EventLoopFuture<EditRecordResponse> where T: Encodable {
        let url = "https://\(self.configuration.hostname)/fmi/data/v1/databases/\(self.configuration.databaseName)/layouts/\(layout)/records/\(id)"
        return self.performOperation(url: url, data: data).flatMapThrowing { response in
            return try self.validateAndGetResponse(response, type: EditRecordResponse.self, action: "edit record")
        }
    }
}
