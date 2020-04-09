import Foundation
import NIO

public extension FileMakerNIO {
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

