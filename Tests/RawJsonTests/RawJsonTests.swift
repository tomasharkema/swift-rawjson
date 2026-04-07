//
//  RawJsonTests.swift
//
//
//  Created by Tomas Harkema on 19/06/2023.
//

import XCTest

@testable import RawJson

final class RawJsonTests: XCTestCase {
  private func encode(in value: RawJson) throws -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .sortedKeys
    let json = try encoder.encode(value)
    return String(data: json, encoding: .utf8)!
  }

  private func decode(in value: String) throws -> RawJson {
    try JSONDecoder().decode(RawJson.self, from: value.data(using: .utf8)!)
  }

  func testBool() throws {
    let obj = RawJson.bool(true)
    let jsonString = try encode(in: obj)

    XCTAssertEqual(jsonString, "true")

    let back = try decode(in: jsonString)

    XCTAssertEqual(obj, back)
  }

  func testDouble() throws {
    let obj = RawJson.double(1)
    let jsonString = try encode(in: obj)

    XCTAssertEqual(jsonString, "1")

    let back = try decode(in: jsonString)

    XCTAssertEqual(obj, back)
  }

  func testString() throws {
    let obj = RawJson.string("test")
    let jsonString = try encode(in: obj)

    XCTAssertEqual(jsonString, "\"test\"")

    let back = try decode(in: jsonString)

    XCTAssertEqual(obj, back)
  }

  func testNull() throws {
    let obj = RawJson.null
    let jsonString = try encode(in: obj)

    XCTAssertEqual(jsonString, "null")

    let back = try decode(in: jsonString)

    XCTAssertEqual(obj, back)
  }

  func testArrayBool() throws {
    let obj = RawJson.array([
      RawJson.bool(true),
      RawJson.bool(true),
      RawJson.bool(false),
    ])
    let jsonString = try encode(in: obj)

    XCTAssertEqual(jsonString, "[true,true,false]")

    let back = try decode(in: jsonString)

    XCTAssertEqual(obj, back)
  }

  func testArrayDouble() throws {
    let obj = RawJson.array([
      RawJson.double(1),
      RawJson.double(2),
      RawJson.double(3.1),
    ])
    let jsonString = try encode(in: obj)

    XCTAssertEqual(jsonString, "[1,2,3.1]")

    let back = try decode(in: jsonString)

    XCTAssertEqual(obj, back)
  }

  func testArrayString() throws {
    let obj = RawJson.array([
      RawJson.string("test"),
      RawJson.string("tomas"),
      RawJson.string("hallo"),
    ])
    let jsonString = try encode(in: obj)

    XCTAssertEqual(jsonString, "[\"test\",\"tomas\",\"hallo\"]")

    let back = try decode(in: jsonString)

    XCTAssertEqual(obj, back)
  }

  func testArrayMixed() throws {
    let obj = RawJson.array([
      RawJson.bool(true),
      RawJson.double(1),
      RawJson.double(2.4),
      RawJson.string("string"),
    ])
    let jsonString = try encode(in: obj)

    XCTAssertEqual(jsonString, "[true,1,2.4,\"string\"]")

    let back = try decode(in: jsonString)

    XCTAssertEqual(obj, back)
  }

  func testDictBool() throws {
    let obj = RawJson.dictionary([
      "test": RawJson.bool(true),
      "tomas": RawJson.bool(true),
      "hallo": RawJson.bool(false),
    ])
    let jsonString = try encode(in: obj)

    XCTAssertEqual(jsonString, "{\"hallo\":false,\"test\":true,\"tomas\":true}")

    let back = try decode(in: jsonString)

    XCTAssertEqual(obj, back)
  }

  func testDictDouble() throws {
    let obj = RawJson.dictionary([
      "test": RawJson.double(1),
      "tomas": RawJson.double(2),
      "hallo": RawJson.double(3.4),
    ])
    let jsonString = try encode(in: obj)

    XCTAssertEqual(jsonString, "{\"hallo\":3.4,\"test\":1,\"tomas\":2}")

    let back = try decode(in: jsonString)

    XCTAssertEqual(obj, back)
  }

  func testDictString() throws {
    let obj = RawJson.dictionary([
      "test": RawJson.string("test"),
      "tomas": RawJson.string("tomas"),
      "hallo": RawJson.string("hallo"),
    ])
    let jsonString = try encode(in: obj)

    XCTAssertEqual(jsonString, "{\"hallo\":\"hallo\",\"test\":\"test\",\"tomas\":\"tomas\"}")

    let back = try decode(in: jsonString)

    XCTAssertEqual(obj, back)
  }

  func testDictMixed() throws {
    let obj = RawJson.dictionary([
      "bool": RawJson.bool(true),
      "int": RawJson.double(1),
      "double": RawJson.double(2.1),
      "string": RawJson.string("string"),
    ])
    let jsonString = try encode(in: obj)

    XCTAssertEqual(jsonString, "{\"bool\":true,\"double\":2.1,\"int\":1,\"string\":\"string\"}")

    let back = try decode(in: jsonString)

    XCTAssertEqual(obj, back)
  }
}
