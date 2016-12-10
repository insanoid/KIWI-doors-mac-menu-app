//
//  Address.swift
//
//  Created by Karthikeya Udupa K M on 09/12/2016
//  Copyright (c) Karthikeya Udupa K M. All rights reserved.
//

import Foundation
import Marshal

public final class Address: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let state = "state"
    static let city = "city"
    static let lng = "lng"
    static let street = "street"
    static let lat = "lat"
    static let postalCode = "postal_code"
    static let country = "country"
  }

  // MARK: Properties
  public var state: String?
  public var city: String?
  public var lng: Float?
  public var street: String?
  public var lat: Float?
  public var postalCode: String?
  public var country: String?

  // MARK: Marshal Initializers

  /// Map a JSON object to this class using Marshal.
  ///
  /// - parameter object: A mapping from ObjectMapper
  public required init(object: MarshaledObject) {
    state = try? object.value(for: SerializationKeys.state)
    city = try? object.value(for: SerializationKeys.city)
    lng = try? object.value(for: SerializationKeys.lng)
    street = try? object.value(for: SerializationKeys.street)
    lat = try? object.value(for: SerializationKeys.lat)
    postalCode = try? object.value(for: SerializationKeys.postalCode)
    country = try? object.value(for: SerializationKeys.country)
  }

}
