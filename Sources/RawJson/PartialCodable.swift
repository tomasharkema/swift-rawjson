//
//  PartialCodable.swift
//
//
//  Created by Tomas Harkema on 17/06/2023.
//

import Foundation

/// A type to fallback to a raw representation of the JSON object if parsing of the `ConcreteType` fails.
/// You'll get both the parsed value and the raw json. If parsing fails, you'll also get an error through the `.error` member.
///
/// Use this type either as a top level catch, or for certain sub values.
///
/// Example:
/// ```swift
///
/// // Top level example
///
/// struct Model: Codable {
///   let test: String
/// }
///
/// try JSONDecoder().decode([PartialCodable<Model>].self, from: data)
///
/// // Nested example
///
/// private struct NestedModel: Codable, Equatable {
///   let test: PartialCodable<String>
/// }
///
/// let object = try JSONDecoder().decode(NestedModel.self, from: data)
///
/// object.value // NestedModel(test: .value("tomas"))
///
/// ```
public struct PartialCodable<ConcreteType>: Codable where ConcreteType: Codable {
  public let value: ConcreteType?
  public let raw: RawJson
  public let error: Error?

  internal init(value: ConcreteType?, raw: RawJson) {
    self.value = value
    self.raw = raw
    error = nil
  }

  public init(from decoder: Decoder) throws {
    raw = try RawJson(from: decoder)
    do {
      value = try ConcreteType(from: decoder)
      error = nil
    } catch {
      self.error = error
      value = nil
    }
  }

  public func encode(to encoder: Encoder) throws {
    switch raw {
    case .dictionary:
      try raw.encode(to: encoder)
      if let value {
        try value.encode(to: encoder)
      }

    default:
      if let value {
        try value.encode(to: encoder)
      } else {
        try raw.encode(to: encoder)
      }
    }
  }
}

extension PartialCodable: Equatable where ConcreteType: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.value == rhs.value && lhs.raw == rhs.raw
  }
}

extension PartialCodable: Sendable where ConcreteType: Sendable {}
