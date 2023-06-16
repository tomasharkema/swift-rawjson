
// import FoundationPreview
import Foundation

public enum RawJson: Codable {
  case bool(Bool)
  case double(Double)
  case string(String)
  indirect case array([RawJson])
  indirect case dictionary([String: RawJson])

  public init(from decoder: Decoder) throws {
    if let container = try? decoder.container(keyedBy: JSONCodingKeys.self) {
      self = RawJson(from: container)
    } else if let container = try? decoder.unkeyedContainer() {
      self = RawJson(from: container)
    } else {
      throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
    }
  }

  private init(from container: KeyedDecodingContainer<JSONCodingKeys>) {
    var dict: [String: RawJson] = [:]
    for key in container.allKeys {
      if let value = try? container.decode(Bool.self, forKey: key) {
        dict[key.stringValue] = .bool(value)
      } else if let value = try? container.decode(Double.self, forKey: key) {
        dict[key.stringValue] = .double(value)
      } else if let value = try? container.decode(String.self, forKey: key) {
        dict[key.stringValue] = .string(value)
      } else if let value = try? container.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key) {
        dict[key.stringValue] = RawJson(from: value)
      } else if let value = try? container.nestedUnkeyedContainer(forKey: key) {
        dict[key.stringValue] = RawJson(from: value)
      }
    }
    self = .dictionary(dict)
  }

  private init(from container: UnkeyedDecodingContainer) {
    var container = container
    var arr: [RawJson] = []
    while !container.isAtEnd {
      if let value = try? container.decode(Bool.self) {
        arr.append(.bool(value))
      } else if let value = try? container.decode(Double.self) {
        arr.append(.double(value))
      } else if let value = try? container.decode(String.self) {
        arr.append(.string(value))
      } else if let value = try? container.nestedContainer(keyedBy: JSONCodingKeys.self) {
        arr.append(RawJson(from: value))
      } else if let value = try? container.nestedUnkeyedContainer() {
        arr.append(RawJson(from: value))
      }
    }
    self = .array(arr)
  }

  public func encode(to encoder: Encoder) throws {

    switch self {
    case .bool(let value):
      var container = encoder.singleValueContainer()
      try container.encode(value)

    case .double(let value):
      var container = encoder.singleValueContainer()
      try container.encode(value)

    case .string(let value):
      var container = encoder.singleValueContainer()
      try container.encode(value)

    case .array(let value):
      var container = encoder.unkeyedContainer()

      for item in value {
        try container.encode(item)
      }

    case .dictionary(let dict):
      var container = encoder.container(keyedBy: JSONCodingKeys.self)

      for (key, value) in dict {
        try container.encode(value, forKey: JSONCodingKeys(stringValue: key)!)
      }
    }
  }
}

struct JSONCodingKeys: CodingKey {
  var stringValue: String

  init?(stringValue: String) {
    self.stringValue = stringValue
  }

  var intValue: Int?

  init?(intValue: Int) {
    self.init(stringValue: "\(intValue)")
    self.intValue = intValue
  }
}

public struct PartialCodable<ConcreteType>: Codable where ConcreteType: Codable {
  public let value: ConcreteType
  public let raw: RawJson

  public init(from decoder: Decoder) throws {
    raw = try RawJson(from: decoder)
    value = try ConcreteType.init(from: decoder)
  }

  public func encode(to encoder: Encoder) throws {
    try raw.encode(to: encoder)
    try value.encode(to: encoder)
  }
}
