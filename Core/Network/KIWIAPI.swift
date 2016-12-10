//
//  Router.swift
//  KIWI
//
//  Created by Karthik on 07/12/2016.
//  Copyright © 2016 Karthik. All rights reserved.
//

import Foundation
import Alamofire
import Marshal

/// API end-points for KIWI app.
///
/// - authenticate: Authenticate the user with the credentials.
/// - sensors: Fetch the sensors available to the user.
/// - activate: Activate the current sensor.
public enum KIWIAPI {
    case authenticate(user: User)
    case sensors(session: Session)
    case activate(sensor: Sensors, session: Session)
}

/// A protocol that any instance of an API client must provide.
protocol APIInstance {
    static var base: String { get }
    static var baseURL: URL { get }
    var method: Alamofire.HTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var encoding: ParameterEncoding { get }
    var headerParameters: [String: String]? { get }
}


/// An API resource request that can handle both the API call and also parse the response into appropriate model.
public struct KIWIAPIResource<A> where A: Model {
    let api: KIWIAPI
    func parse(object: MarshaledObject) -> A? {
        //Can have switch for API, we can customise it to handle different methods differently, try different classes etc.
        return A(object: object)
    }
}


extension KIWIAPI: APIInstance {

    static var base: String { return "https://api.kiwi.ki/pre/" }

    static var baseURL: URL { return URL(string: base)! }

    public var method: Alamofire.HTTPMethod {
        switch self {
        case .authenticate(_):
            return .post
        case .sensors(_):
            return .get
        case .activate(_, _):
            return .post
        }
    }

    public var path: String {
        switch self {
        case .authenticate:
            return "session/"
        case .sensors:
            return "sensors/"
        case .activate(let sensor, _):
            var id = 0
            if let sensorId = sensor.sensorId {
                id = sensorId
            }
            return "sensors/\(id)/act/open"
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .authenticate(let user):
            return [
                "username": user.email,
                "password": user.password
            ]
        case .sensors(let session):
            return [
                "page_number": 1,
                "page_size": 999999,
                "session_key": session.sessionKey!
            ]
        case .activate(_, let session):
            return [
                "session_key": session.sessionKey!
            ]
        }
    }

    public var encoding: ParameterEncoding {
        switch self {
        case .sensors(_):
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }

    public var headerParameters: [String: String]? {
        switch self {
        case .sensors(_):
            return [
                "X-Requested-With": "XMLHttpRequest",
                "Content-Type": "application/json; charset=utf-8",
                "Accept": "application/json, text/javascript, */*; q=0.01"
            ]
        case .activate(_, _):
            return [
                "X-Requested-With": "XMLHttpRequest",
                "Content-Type": "application/json; charset=utf-8",
                "Accept": "application/json, text/javascript, */*; q=0.01"
            ]
        default:
            return nil
        }
    }

    func url() -> URL {
        return KIWIAPI.baseURL.appendingPathComponent(self.path)
    }
}
