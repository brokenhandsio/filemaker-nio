import Foundation

public protocol FMIdentifiable: class, Codable {
    var recordId: String? { get set }
    var modId: String? { get set }
}
