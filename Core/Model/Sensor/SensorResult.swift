//
//  SensorResult.swift
//
//  Created by Karthikeya Udupa K M on 09/12/2016
//  Copyright (c) Karthikeya Udupa K M. All rights reserved.
//

import Foundation
import Marshal

public final class SensorResult: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let sortBy = "sort_by"
    static let orderBy = "order_by"
    static let sensors = "sensors"
    static let pageNumber = "page_number"
    static let pageSize = "page_size"
    static let totalResults = "total_results"
  }

  // MARK: Properties
  public var sortBy: String?
  public var orderBy: String?
  public var sensors: [Sensors]?
  public var pageNumber: Int?
  public var pageSize: Int?
  public var totalResults: Int?

  // MARK: Marshal Initializers

  /// Map a JSON object to this class using Marshal.
  ///
  /// - parameter object: A mapping from ObjectMapper
  public required init(object: MarshaledObject) {
    sortBy = try? object.value(for: SerializationKeys.sortBy)
    orderBy = try? object.value(for: SerializationKeys.orderBy)
    sensors = try? object.value(for: SerializationKeys.sensors)
    pageNumber = try? object.value(for: SerializationKeys.pageNumber)
    pageSize = try? object.value(for: SerializationKeys.pageSize)
    totalResults = try? object.value(for: SerializationKeys.totalResults)
  }

}
