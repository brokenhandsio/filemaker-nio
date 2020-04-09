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
    
    func getRecord<T>(_ id: Int, layout: String, decodeTo type: T) -> EventLoopFuture<T> where  T: Codable {
        let url = "https://\(self.configuration.hostname)/fmi/data/v1/databases/\(self.configuration.databaseName)/layouts/\(layout)/records/\(id)"
        return self.performOperation(url: url, type: GetRecordResponse<T>.self).map { getRecordResponse in
            getRecordResponse.data
        }
    }
    
    func getRecords<T>(layout: String, decodeTo type: T, offset: Int?, limit: Int?) -> EventLoopFuture<[T]> where T: Codable {
        var url  = "https://\(self.configuration.hostname)/fmi/data/version/databases/\(self.configuration.databaseName)/layouts/\(layout)/records"
        if offset != nil || limit != nil {
            url += "?"
        }
        if let offset = offset {
            url += "_offset=\(offset)"
        }
        if let limit = limit {
            if offset != nil {
                url += "&"
            }
            url += "_limit=\(limit)"
        }
        return self.performOperation(url: url, type: GetRangeOfRecordsResponse<T>.self).map { getRangeOfRecordsResponse in
            getRangeOfRecordsResponse.data
        }
    }
    
    func findRecords<T, R>(layout: String, payload:T, decodeTo type: R) -> EventLoopFuture<[R]> where T: Codable, R: Codable {
        let url = "https://\(self.configuration.hostname)/fmi/data/version/databases/\(self.configuration.databaseName)/layouts/\(layout)/_find"
        return self.performOperation(url: url, data: payload, type: FindRecordsResponse<R>.self).map { findResponse in
            findResponse.data
        }
    }
}

