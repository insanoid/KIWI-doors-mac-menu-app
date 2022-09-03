//
//  SensorListViewController.swift
//  KIWI
//
//  Created by Karthik on 10/12/2016.
//  Copyright © 2016 Karthik. All rights reserved.
//

import Cocoa
import Foundation

/// Default dimensions for the view.
///
/// - width: Default width.
/// - maxHeight: Maximum possible widdth.
/// - height: Default height.
/// - bottomSectionHeight: Height of the bottom bar for settings/refresh.
public enum DefaultDimensions: Int {
    case width = 335
    case height = 250
    case maxHeight = 350
    case bottomSectionHeight = 30
}


/// A enum to store all the notification and to generate to required type.
///
/// - heightChange: Whenever the height of view has to be altered.
/// - dismiss: Dismiss the view.
public enum PopoverBehaviorNotification: String {
    case heightChange = "PopOverHeightChange"
    case dismiss = "PopOverDismiss"

    func name() -> Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}


/// The main view which shows the list of sensor with other options like refresh, settings and loading states.
class SensorListViewController: NSViewController {

    @IBOutlet weak var productTableView: NSTableView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var refreshButton: NSButton!
    @IBOutlet weak var settingsButton: NSButton!
    @IBOutlet weak var statusLabel: NSTextField!


    /// List of sensors presently available, reload the tableview everytime the sensor list if changed.
    var sensors = [Sensors]() {
        didSet {
            self.productTableView.reloadData()
        }
    }

    /// Preferred height for the view based on the current state and restrictings.
    var preferredViewHeight: Int {
        get {
            if sensors.count > 0 && self.loadingView.isHidden {
                let requiredHeight = DefaultDimensions.bottomSectionHeight.rawValue + (sensors.count * SensorCell.height)
                return requiredHeight > DefaultDimensions.maxHeight.rawValue ? DefaultDimensions.maxHeight.rawValue : requiredHeight
            }
            return 250
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        loadData()
    }

    func setupUI() {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
        productTableView.backgroundColor = NSColor.white
        productTableView.intercellSpacing = NSSize.zero
        productTableView.gridColor = NSColor.lightGray.withAlphaComponent(0.5)
        refreshButton.image = #imageLiteral(resourceName: "icon-reload").tintedImageWithColor(color: NSColor.black)
        settingsButton.image = #imageLiteral(resourceName: "icon-settings").tintedImageWithColor(color: NSColor.black)
        self.statusLabel.stringValue = ""
        self.statusLabel.textColor = NSColor.darkGray.withAlphaComponent(0.5)
    }

    func loadData() {
        self.sensors = []
        loadingView.showState(state: .loading)

        if Defaults.isSessionAvailable() {
            loadSensors()
        } else if Defaults.isCredentialAvailable() {
            startSession()
        } else {
            loadingView.showState(state: .noAuth)
        }
    }
}


// MARK: - TableView Delegates and Datasource Methods.
extension SensorListViewController: NSTableViewDelegate, NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        notifyHeightChange()
        return sensors.count
    }

    func tableView(_ tableView: NSTableView,
                   viewFor tableColumn: NSTableColumn?,
                   row: Int) -> NSView? {
        return SensorCell.view(tableView: tableView, owner: self, subject: sensors[row])
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return CGFloat.init(SensorCell.height)
    }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if row < sensors.count {
            let sensor = sensors[row]
            activate(sensor)
        }
        return true
    }
}

extension SensorListViewController {

    func startSession() {

        guard let user = Defaults.currentUser() else {
            self.loadingView.showState(state: .customState("Error authenticating, check your login information."))
            return
        }

        let network = KIWINetwork<AuthenticationResponse>()
        let api = KIWIAPI.authenticate(user: user)
        let _ = network.request(resource: api).subscribe(onNext: { response in
                if let session = response?.authenticationResult?.session {
                    Defaults.save(session: session)
                    self.loadData()
                }
        }, onError: { error in
                self.loadingView.showState(state: .customState("Error authenticating, check your login information."))

        })
    }

    func loadSensors() {
        guard let session = Defaults.currentSession() else {
            Defaults.removeSession()
            self.loadingView.showState(state: .customState("Issue with session."))
            self.loadData()
            return
        }

        let network = KIWINetwork<SensorResponse>()
        let api = KIWIAPI.sensors(session: session)
        let _ = network.request(resource: api).subscribe(onNext: { response in
            if let sensors = response?.sensorResult?.sensors, sensors.count > 0 {
                self.loadingView.showState(state: .idle)
                self.sensors = sensors
            } else {
                self.loadingView.showState(state: .empty)
                self.sensors = []
            }
        }, onError: { error in
            self.resetSession()
        })
    }

    func activate(_ sensor: Sensors) {



        guard let session = Defaults.currentSession() else {
            resetSession()
            return
        }

        self.statusLabel.stringValue = "Opening…"
        self.loadingView.showState(state: .customState("Opening the door…"))
        self.notifyHeightChange()
        let network = KIWINetwork<SensorActivationResponse>()
        let api = KIWIAPI.activate(sensor: sensor, session: session)
        let _ = network.request(resource: api).subscribe(onNext: { response in
            self.loadingView.showState(state: .idle)
            if let status = response?.status, status == "ok" {
                self.statusLabel.stringValue = "Door Opened."
                NSSound(named: "Hero")?.play()
            } else {
                NSSound(named: "Basso")?.play()
                self.statusLabel.stringValue = "Unable to open the door, try again."
                self.resetSession()
            }
            self.notifyHeightChange()
        }, onError: { error in
            NSSound(named: "Basso")?.play()
            self.statusLabel.stringValue = "Unable to open the door, try again."
            self.loadingView.showState(state: .idle)
            self.resetSession()
        }, onCompleted: {
            // Once completed, vanish the logo.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.statusLabel.stringValue = ""
            })
        })
    }

    func resetSession() {
        Defaults.removeSession()
        self.loadData()
    }
}


// MARK: - Notification process
extension SensorListViewController {
    func notifyHeightChange() {
        let notification = Notification.init(
                                             name: PopoverBehaviorNotification.heightChange.name(),
                                             object: nil,
                                             userInfo: ["height": preferredViewHeight])
        NotificationCenter.default.post(notification)
    }

    func notifyDismissPopover() {
        let notification = Notification.init(
                                             name: PopoverBehaviorNotification.dismiss.name())
        NotificationCenter.default.post(notification)
    }
}


// MARK: - Actions that the user can take on the interface.
extension SensorListViewController {
    @IBAction func refreshInformation(_ sender: AnyObject?) {
        Defaults.removeSession()
        loadData()
    }

    @IBAction func showSettings(_ sender: AnyObject?) {
        notifyDismissPopover()
        self.presentAsModalWindow(AuthenticationViewController(nibName: AuthenticationViewController.className(), bundle: nil))
    }
}


// MARK: - An extension to handle tinting of images.
fileprivate extension NSImage {
    func tintedImageWithColor(color: NSColor) -> NSImage {
        let size = self.size
        let imageBounds = NSMakeRect(0, 0, size.width, size.height)
        if let copiedImage = self.copy() as? NSImage {
            copiedImage.lockFocus()
            color.set()
            imageBounds.fill(using: .sourceAtop)
            copiedImage.unlockFocus()
            return copiedImage
        }
        return self
    }
}
