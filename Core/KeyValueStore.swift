//
//  KeyValueStore.swift
//  KIWI
//
//  Created by Karthik on 10/12/2016.
//  Copyright © 2016 Karthik. All rights reserved.
//

import Foundation


/// Keys against which the data has to be stored in the storage method.
///
/// - username: Email of the user.
/// - password: Password of the user.
/// - session: Session information.
fileprivate enum Keys: String {
    case username = "email"
    case password = "password"
    case session = "session"
}


/// A basic protocol for any key/value store interface to follow.
public protocol KeyValueStore {
    static func save(key: String, value: Any?)
    static func value(forKey: String) -> Any?
    static func remove(forKey: String)
    static func reset()
}


/// Additional protocols that our app requires.
public protocol KIWIKeyValueStore {
    static func save(user: User)
    static func save(session: Session)
    static func currentUser() -> User?
    static func currentSession() -> Session?
    static func isCredentialAvailable() -> Bool
    static func isSessionAvailable() -> Bool
    static func removeAuth()
    static func removeSession()
}


/// A key value store method using `UserDefaults` to store the data.
enum Defaults: KeyValueStore, KIWIKeyValueStore {

    static func save(key: String, value: Any?) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    static func remove(forKey: String) {
        UserDefaults.standard.removeObject(forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    static func value(forKey: String) -> Any? {
        return UserDefaults.standard.value(forKey: forKey)
    }

    static func reset() {
        remove(forKey: Keys.username.rawValue)
        remove(forKey: Keys.password.rawValue)
        remove(forKey: Keys.session.rawValue)
    }


    static func currentUser() -> User? {
        let email = value(forKey: Keys.username.rawValue)
        let password = value(forKey: Keys.password.rawValue)

        if let email = email as? String, let password = password as? String {
            return User(email: email, password: password)
        }
        return nil
    }
    static func currentSession() -> Session? {
        let sessionKey = value(forKey: Keys.session.rawValue)

        if let sessionKey = sessionKey as? String {
            return Session.init(object: ["session_key": sessionKey])
        }
        return nil
    }

    static func isCredentialAvailable() -> Bool {
        if let _ = currentUser() {
            return true
        }
        return false
    }
    static func isSessionAvailable() -> Bool {
        if let _ = currentSession() {
            return true
        }
        return false
    }
    static func removeAuth() {
        reset()
    }
    static func removeSession() {
        remove(forKey: Keys.session.rawValue)
    }
    static func save(user: User) {
        save(key: Keys.username.rawValue, value: user.email)
        save(key: Keys.password.rawValue, value: user.password)
    }

    static func save(session: Session) {
        save(key: Keys.session.rawValue, value: session.sessionKey)
    }

}
