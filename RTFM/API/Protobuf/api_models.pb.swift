// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: api_models.proto
//
// For information on using the generated types, please see the documenation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that your are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct Point {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var latitude: Double = 0

  var longitude: Double = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct SignalPoint {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var latitude: Double = 0

  var longitude: Double = 0

  var reliability: Double = 0

  var signal: Double = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct AddMeasureRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var latitude: Double = 0

  var longitude: Double = 0

  var signal: Double = 0

  var operatorName: String = String()

  var userID: Int64 = 0

  var time: Int64 = 0

  var networkName: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct SignalMapRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var borderPoints: [Point] = []

  var operatorName: String = String()

  var networkName: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct SignalMapResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var points: [SignalPoint] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct ScoreRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var userID: Int64 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct ScoreResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var score: Double = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension Point: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "Point"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "Latitude"),
    2: .same(proto: "Longitude"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularDoubleField(value: &self.latitude)
      case 2: try decoder.decodeSingularDoubleField(value: &self.longitude)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.latitude != 0 {
      try visitor.visitSingularDoubleField(value: self.latitude, fieldNumber: 1)
    }
    if self.longitude != 0 {
      try visitor.visitSingularDoubleField(value: self.longitude, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Point, rhs: Point) -> Bool {
    if lhs.latitude != rhs.latitude {return false}
    if lhs.longitude != rhs.longitude {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SignalPoint: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "SignalPoint"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "Latitude"),
    2: .same(proto: "Longitude"),
    3: .same(proto: "Reliability"),
    4: .same(proto: "Signal"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularDoubleField(value: &self.latitude)
      case 2: try decoder.decodeSingularDoubleField(value: &self.longitude)
      case 3: try decoder.decodeSingularDoubleField(value: &self.reliability)
      case 4: try decoder.decodeSingularDoubleField(value: &self.signal)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.latitude != 0 {
      try visitor.visitSingularDoubleField(value: self.latitude, fieldNumber: 1)
    }
    if self.longitude != 0 {
      try visitor.visitSingularDoubleField(value: self.longitude, fieldNumber: 2)
    }
    if self.reliability != 0 {
      try visitor.visitSingularDoubleField(value: self.reliability, fieldNumber: 3)
    }
    if self.signal != 0 {
      try visitor.visitSingularDoubleField(value: self.signal, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SignalPoint, rhs: SignalPoint) -> Bool {
    if lhs.latitude != rhs.latitude {return false}
    if lhs.longitude != rhs.longitude {return false}
    if lhs.reliability != rhs.reliability {return false}
    if lhs.signal != rhs.signal {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension AddMeasureRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "AddMeasureRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "Latitude"),
    2: .same(proto: "Longitude"),
    3: .same(proto: "Signal"),
    4: .same(proto: "OperatorName"),
    5: .same(proto: "UserId"),
    6: .same(proto: "Time"),
    7: .same(proto: "NetworkName"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularDoubleField(value: &self.latitude)
      case 2: try decoder.decodeSingularDoubleField(value: &self.longitude)
      case 3: try decoder.decodeSingularDoubleField(value: &self.signal)
      case 4: try decoder.decodeSingularStringField(value: &self.operatorName)
      case 5: try decoder.decodeSingularInt64Field(value: &self.userID)
      case 6: try decoder.decodeSingularInt64Field(value: &self.time)
      case 7: try decoder.decodeSingularStringField(value: &self.networkName)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.latitude != 0 {
      try visitor.visitSingularDoubleField(value: self.latitude, fieldNumber: 1)
    }
    if self.longitude != 0 {
      try visitor.visitSingularDoubleField(value: self.longitude, fieldNumber: 2)
    }
    if self.signal != 0 {
      try visitor.visitSingularDoubleField(value: self.signal, fieldNumber: 3)
    }
    if !self.operatorName.isEmpty {
      try visitor.visitSingularStringField(value: self.operatorName, fieldNumber: 4)
    }
    if self.userID != 0 {
      try visitor.visitSingularInt64Field(value: self.userID, fieldNumber: 5)
    }
    if self.time != 0 {
      try visitor.visitSingularInt64Field(value: self.time, fieldNumber: 6)
    }
    if !self.networkName.isEmpty {
      try visitor.visitSingularStringField(value: self.networkName, fieldNumber: 7)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: AddMeasureRequest, rhs: AddMeasureRequest) -> Bool {
    if lhs.latitude != rhs.latitude {return false}
    if lhs.longitude != rhs.longitude {return false}
    if lhs.signal != rhs.signal {return false}
    if lhs.operatorName != rhs.operatorName {return false}
    if lhs.userID != rhs.userID {return false}
    if lhs.time != rhs.time {return false}
    if lhs.networkName != rhs.networkName {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SignalMapRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "SignalMapRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "BorderPoints"),
    2: .same(proto: "OperatorName"),
    3: .same(proto: "NetworkName"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeRepeatedMessageField(value: &self.borderPoints)
      case 2: try decoder.decodeSingularStringField(value: &self.operatorName)
      case 3: try decoder.decodeSingularStringField(value: &self.networkName)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.borderPoints.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.borderPoints, fieldNumber: 1)
    }
    if !self.operatorName.isEmpty {
      try visitor.visitSingularStringField(value: self.operatorName, fieldNumber: 2)
    }
    if !self.networkName.isEmpty {
      try visitor.visitSingularStringField(value: self.networkName, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SignalMapRequest, rhs: SignalMapRequest) -> Bool {
    if lhs.borderPoints != rhs.borderPoints {return false}
    if lhs.operatorName != rhs.operatorName {return false}
    if lhs.networkName != rhs.networkName {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SignalMapResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "SignalMapResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "Points"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeRepeatedMessageField(value: &self.points)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.points.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.points, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SignalMapResponse, rhs: SignalMapResponse) -> Bool {
    if lhs.points != rhs.points {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ScoreRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "ScoreRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "user_id"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularInt64Field(value: &self.userID)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.userID != 0 {
      try visitor.visitSingularInt64Field(value: self.userID, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: ScoreRequest, rhs: ScoreRequest) -> Bool {
    if lhs.userID != rhs.userID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ScoreResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "ScoreResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    2: .same(proto: "Score"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 2: try decoder.decodeSingularDoubleField(value: &self.score)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.score != 0 {
      try visitor.visitSingularDoubleField(value: self.score, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: ScoreResponse, rhs: ScoreResponse) -> Bool {
    if lhs.score != rhs.score {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
