//
//  Sensors.swift
//
//  Created by Karthikeya Udupa K M on 09/12/2016
//  Copyright (c) Karthikeya Udupa K M. All rights reserved.
//

import Foundation
import Marshal

public final class Sensors: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let sensorUuid = "sensor_uuid"
    static let hardwareType = "hardware_type"
    static let canInvite = "can_invite"
    static let isOwner = "is_owner"
    static let address = "address"
    static let sensorId = "sensor_id"
    static let highestPermission = "highest_permission"
  }

  // MARK: Properties
  public var sensorUuid: String?
  public var hardwareType: String?
  public var canInvite: Bool? = false
  public var isOwner: Bool? = false
  public var address: Address?
  public var sensorId: Int?
  public var highestPermission: String?

  // MARK: Marshal Initializers

  /// Map a JSON object to this class using Marshal.
  ///
  /// - parameter object: A mapping from ObjectMapper
  public required init(object: MarshaledObject) {
    sensorUuid = try? object.value(for: SerializationKeys.sensorUuid)
    hardwareType = try? object.value(for: SerializationKeys.hardwareType)
    canInvite = try? object.value(for: SerializationKeys.canInvite)
    isOwner = try? object.value(for: SerializationKeys.isOwner)
    address = try? object.value(for: SerializationKeys.address)
    sensorId = try? object.value(for: SerializationKeys.sensorId)
    highestPermission = try? object.value(for: SerializationKeys.highestPermission)
  }

}
