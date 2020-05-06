import Foundation

@propertyWrapper
public final class FMInt: Codable {
    
    public var value: Int?
    
    public init(wrappedValue value: Int?) {
        self.value = value
    }
    
    public var wrappedValue: Int? {
        get { value }
        set { value = newValue }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self.wrappedValue = intValue
        } else {
            let stringValue = try container.decode(String.self)
            if stringValue == "" {
                self.wrappedValue = nil
            } else {
                throw FileMakerNIOError(message: "Invalid type when decoding FMInt")
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }
}

