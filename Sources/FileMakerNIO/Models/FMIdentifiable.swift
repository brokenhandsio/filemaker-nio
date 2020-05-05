import Foundation

public protocol FMIdentifiable: class, Codable {
    var recordId: Int? { get set }
    var modId: Int? { get set }
}
