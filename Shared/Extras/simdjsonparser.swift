//
//  simdjsonparser.swift
//  PearDB
//
//  Created by Amelia While on 31/08/2025.
//

#if canImport(ZippyJSON)
import ZippyJSON

typealias PJSONDecoder = ZippyJSONDecoder
#else
import Foundation

typealias PJSONDecoder = JSONDecoder
#endif
