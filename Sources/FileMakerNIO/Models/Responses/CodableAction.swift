import Foundation
import NIOHTTP1

protocol CodableAction: Codable {
    static var action: String { get }
    static var method: HTTPMethod { get }
}
