//
//  Session.swift
//
//  Created by Karthikeya Udupa K M on 07/12/2016
//  Copyright (c) Karthikeya Udupa K M. All rights reserved.
//

import Foundation
import Marshal

public final class Session: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let sessionKey = "session_key"
    static let maxExpires = "max_expires"
    static let enabled = "enabled"
    static let userId = "user_id"
    static let accountVerification = "account_verification"
    static let expires = "expires"
    static let username = "username"
  }

  // MARK: Properties
  public var sessionKey: String?
  public var maxExpires: String?
  public var enabled: String?
  public var userId: Int?
  public var accountVerification: Int?
  public var expires: String?
  public var username: String?

  // MARK: Marshal Initializers

  /// Map a JSON object to this class using Marshal.
  ///
  /// - parameter object: A mapping from ObjectMapper
  public required init(object: MarshaledObject) {
    sessionKey = try? object.value(for: SerializationKeys.sessionKey)
    maxExpires = try? object.value(for: SerializationKeys.maxExpires)
    enabled = try? object.value(for: SerializationKeys.enabled)
    userId = try? object.value(for: SerializationKeys.userId)
    accountVerification = try? object.value(for: SerializationKeys.accountVerification)
    expires = try? object.value(for: SerializationKeys.expires)
    username = try? object.value(for: SerializationKeys.username)
  }

}
