import Foundation
import NIO

public extension FileMakerNIO {
    
    var layoutsURL: String {
        "\(self.apiBaseURL)layouts/"
    }
    
    func createRecord<T>(layout: String, data: T) -> EventLoopFuture<T> where T: FMIdentifiable {
        let url = "\(self.layoutsURL)\(layout)/records"
        let createData = CreateRecordRequest(fieldData: data)
        return self.performOperation(url: url, data: createData, type: CreateRecordResponse.self).map { response in
            data.modId = Int(response.modId)
            data.recordId = Int(response.recordId)
            return data
        }
    }
    
    func editRecord<T>(_ id: Int, layout: String, data: T) -> EventLoopFuture<EditRecordResponse> where T: Encodable {
        let url = "\(self.layoutsURL)\(layout)/records/\(id)"
        return self.performOperation(url: url, data: data, type: EditRecordResponse.self)
    }
    
    func duplicateRecord<T>(_ id: Int, layout: String, data: T) -> EventLoopFuture<DuplicateRecordResponse> where T: Encodable {
        let url = "\(self.layoutsURL)\(layout)/records/\(id)"
        return self.performOperation(url: url, data: data, type: DuplicateRecordResponse.self)
    }
    
    func deleteRecord(_ id: Int, layout: String) -> EventLoopFuture<Void> {
        let url = "\(self.layoutsURL)\(layout)/records/\(id)"
        return self.performOperation(url: url, type: DeleteRecordResponse.self).map { _ in }
    }
    
    func getRecord<T>(_ id: Int, layout: String, decodeTo type: T) -> EventLoopFuture<T> where  T: Codable {
        let url = "\(self.layoutsURL)\(layout)/records/\(id)"
        return self.performOperation(url: url, type: GetRecordResponse<T>.self).map { getRecordResponse in
            getRecordResponse.data
        }
    }
    
    func getRecords<T>(layout: String, decodeTo type: T.Type, offset: Int? = nil, limit: Int? = nil) -> EventLoopFuture<[T]> where T: Codable {
        var url  = "\(self.layoutsURL)\(layout)/records"
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
        let url = "\(self.layoutsURL)\(layout)/_find"
        return self.performOperation(url: url, data: payload, type: FindRecordsResponse<R>.self).map { findResponse in
            findResponse.data
        }
    }
}



