import Foundation

public struct GetRecordData<T: FMIdentifiable>: Codable {
    let recordId: String
    let modId: String
    let fieldData: T
}

extension GetRecordData {
    func completeModel() -> T {
        let model = self.fieldData
        model.modId = Int(self.modId)
        model.recordId = Int(self.recordId)
        return model
    }
}
