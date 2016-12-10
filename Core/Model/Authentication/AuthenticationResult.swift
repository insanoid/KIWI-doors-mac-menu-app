//
//  AuthenticationResult.swift
//
//  Created by Karthikeya Udupa K M on 07/12/2016
//  Copyright (c) Karthikeya Udupa K M. All rights reserved.
//

import Foundation
import Marshal

public final class AuthenticationResult: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let sessionKey = "session_key"
    static let session = "session"
  }

  // MARK: Properties
  public var sessionKey: String?
  public var session: Session?

  // MARK: Marshal Initializers

  /// Map a JSON object to this class using Marshal.
  ///
  /// - parameter object: A mapping from ObjectMapper
  public required init(object: MarshaledObject) {
    sessionKey = try? object.value(for: SerializationKeys.sessionKey)
    session = try? object.value(for: SerializationKeys.session)
  }

}
