//
//  AuthenticationResponse.swift
//
//  Created by Karthikeya Udupa K M on 07/12/2016
//  Copyright (c) Karthikeya Udupa K M. All rights reserved.
//

import Foundation
import Marshal

public final class AuthenticationResponse: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let authenticationResult = "result"
    static let status = "status"
  }

  // MARK: Properties
  public var authenticationResult: AuthenticationResult?
  public var status: String?

  // MARK: Marshal Initializers

  /// Map a JSON object to this class using Marshal.
  ///
  /// - parameter object: A mapping from ObjectMapper
  public required init(object: MarshaledObject) {
    authenticationResult = try? object.value(for: SerializationKeys.authenticationResult)
    status = try? object.value(for: SerializationKeys.status)
  }

}
