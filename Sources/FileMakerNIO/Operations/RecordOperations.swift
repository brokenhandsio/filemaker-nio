import Foundation
import NIO

public extension FileMakerNIO {
    
    var layoutsURL: String {
        "\(self.apiBaseURL)layouts/"
    }
    
    func createRecord<T>(layout: String, data: T, on eventLoop: EventLoop) -> EventLoopFuture<T> where T: FMIdentifiable {
        let url = "\(self.layoutsURL)\(layout)/records"
        let createData = CreateRecordRequest(fieldData: data)
        return self.performOperation(url: url, data: createData, type: CreateRecordResponse.self, on: eventLoop).map { response in
            data.modId = Int(response.modId)
            data.recordId = Int(response.recordId)
            return data
        }
    }
    
    func editRecord<T>(_ id: Int, layout: String, updateData: T, on eventLoop: EventLoop) -> EventLoopFuture<EditRecordResponse> where T: Codable {
        let url = "\(self.layoutsURL)\(layout)/records/\(id)"
        return self.performOperation(url: url, data: updateData, type: EditRecordResponse.self, on: eventLoop)
    }
    
    func duplicateRecord<T>(_ id: Int, layout: String, decodeTo type: T.Type, on eventLoop: EventLoop) -> EventLoopFuture<DuplicateRecordResponse> where T: Encodable {
        let url = "\(self.layoutsURL)\(layout)/records/\(id)"
        return self.performOperation(url: url, data: EmptyRequest(), type: DuplicateRecordResponse.self, on: eventLoop)
    }
    
    func deleteRecord(_ id: Int, layout: String, on eventLoop: EventLoop) -> EventLoopFuture<Void> {
        let url = "\(self.layoutsURL)\(layout)/records/\(id)"
        return self.performOperation(url: url, type: DeleteRecordResponse.self, on: eventLoop).map { _ in }
    }
    
    func getRecord<T>(_ id: Int, layout: String, decodeTo type: T.Type, on eventLoop: EventLoop) -> EventLoopFuture<T> where  T: FMIdentifiable {
        let url = "\(self.layoutsURL)\(layout)/records/\(id)"
        return self.performOperation(url: url, type: GetRecordResponse<T>.self, on: eventLoop).flatMapThrowing { getRecordResponse in
            guard let record = getRecordResponse.data.first else {
                throw FileMakerNIOError(message: "Record does not exist when it should")
            }
            return record.completeModel()
        }
    }
    
    func getRecords<T>(layout: String, decodeTo type: T.Type, offset: Int? = nil, limit: Int? = nil, on eventLoop: EventLoop) -> EventLoopFuture<[T]> where T: FMIdentifiable {
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
        return self.performOperation(url: url, type: GetRangeOfRecordsResponse<T>.self, on: eventLoop).map { getRangeOfRecordsResponse in
            getRangeOfRecordsResponse.data.map { $0.completeModel() }
        }
    }
    
    func findRecords<T, R>(layout: String, payload:T, decodeTo type: R.Type, on eventLoop: EventLoop) -> EventLoopFuture<[R]> where T: Codable, R: FMIdentifiable {
        let url = "\(self.layoutsURL)\(layout)/_find"
        return self.performOperation(url: url, data: payload, type: FindRecordsResponse<R>.self, on: eventLoop).map { findResponse in
            findResponse.data.map { $0.completeModel() }
        }
    }
}



