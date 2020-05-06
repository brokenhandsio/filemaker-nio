import Foundation

@propertyWrapper
public final class FMTimestamp: Codable {
    
    public var value: Date?
    
    public init(wrappedValue value: Date?) {
        self.value = value
    }
    
    public var wrappedValue: Date? {
        get { value }
        set { value = newValue }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        if stringValue == "" {
            self.wrappedValue = nil
        } else {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy HH:mm:SS"
            self.wrappedValue = dateFormat.date(from: stringValue)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let date = self.wrappedValue {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy HH:mm:SS"
            let dateAsString = dateFormat.string(from: date)
            try container.encode(dateAsString)
        } else {
            try container.encodeNil()
        }
    }
}
