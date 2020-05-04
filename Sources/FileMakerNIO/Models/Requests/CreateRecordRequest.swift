import Foundation

struct CreateRecordRequest<T>: Encodable where T: Encodable {
    let fieldData: T
}
