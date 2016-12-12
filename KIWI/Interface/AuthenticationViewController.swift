//
//  AuthenticationViewController.swift
//  KIWI
//
//  Created by Karthik on 09/12/2016.
//  Copyright © 2016 Karthik. All rights reserved.
//

import Cocoa
import Foundation

/// Simple interface for saving account information.
class AuthenticationViewController: NSViewController {

    @IBOutlet weak var username: NSTextField!
    @IBOutlet weak var password: NSSecureTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Account Information"

    }
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }

    func updateUI() {
        if let user = Defaults.currentUser() {
            username.stringValue = user.email
            password.stringValue = user.password
        } else {
            username.stringValue = ""
            password.stringValue = ""
        }
    }

    //MARK: UI actions.
    @IBAction func save(_ sender: NSButton?) {
        if username.stringValue.characters.count > 0 &&
        password.stringValue.characters.count > 0 {
            Defaults.save(user: User(email: username.stringValue, password: password.stringValue))
        }
        self.view.window?.close()
    }

    @IBAction func logout(_ sender: NSButton?) {
        Defaults.reset()
        updateUI()
    }

    @IBAction func ExitNow(_ sender: NSButton) {
        NSApplication.shared().terminate(self)
    }
}
