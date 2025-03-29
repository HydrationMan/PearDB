//
//  Units.swift
//  PearDB
//
//  Created by Paras KCD on 23/3/25.
//

import Foundation

public struct Units {
  
  public let bytes: Int64
  
  public var kilobytes: Double {
    return Double(bytes) / 1_024
  }
  
  public var megabytes: Double {
    return kilobytes / 1_024
  }
  
  public var gigabytes: Double {
    return megabytes / 1_024
  }
  
  public init(bytes: Int64) {
    self.bytes = bytes
  }
  
  public func getReadableUnit() -> String {
    switch bytes {
    case 0..<1_024:
      return "\(bytes) bytes"
    case 1_024..<(1_024 * 1_024):
      return "\(String(format: "%.0f", kilobytes)) KB"
    case 1_024..<(1_024 * 1_024 * 1_024):
      return "\(String(format: "%.0f", megabytes)) MB"
    case (1_024 * 1_024 * 1_024)...Int64.max:
      return "\(String(format: "%.0f", gigabytes)) GB"
    default:
      return "\(bytes) bytes"
    }
  }
}
