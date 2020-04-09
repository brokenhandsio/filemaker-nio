import Foundation

public protocol CodableAction: Codable {
    static var action: String { get }
}
