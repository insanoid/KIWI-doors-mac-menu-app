//
//  AppDelegate.swift
//  KIWI
//
//  Created by Karthik on 07/12/2016.
//  Copyright © 2016 Karthik. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    /// The window for the app.
    @IBOutlet weak var window: NSWindow!

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let popover = NSPopover()
    var detector: Any?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupAppBarButton()
        setupNotifications()
        presentView()
    }
}


// MARK: - Handle setting up of various components.
extension AppDelegate {

    func setupAppBarButton() {
        if let button = statusItem.button {
            let icon = #imageLiteral(resourceName: "statusIcon")
            icon.isTemplate = true
            button.image = icon
            button.action = #selector(togglePopover(_:))
        }
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(closePopover(_:)),
                                               name: PopoverBehaviorNotification.dismiss.name(),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updatePopverSize(_:)),
                                               name: PopoverBehaviorNotification.heightChange.name(),
                                               object: nil)
    }

    func updatePopverSize(_ notification: Notification) {
        if let userInfo = notification.userInfo, let height = userInfo["height"] as? Int {
            popover.contentSize = CGSize.init(width: DefaultDimensions.width.rawValue, height: height)
        }
    }
}


// MARK: - Handle New View and Popover functions.
extension AppDelegate {

    func presentView() {
        if let view = SensorListViewController(nibName: "SensorListViewController", bundle: nil) {
            popover.contentViewController = view
            popover.contentSize = CGSize.init(width: DefaultDimensions.width.rawValue,
                                              height: view.preferredViewHeight)
        }
    }


    func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            startOutsideAreaClickDetector()
        }
    }

    func closePopover(_ sender: AnyObject? = nil) {
        popover.performClose(statusItem.button)
        stopOutsideAreaClickDetector()
    }
}



// MARK: - Handle `NSEvent` click detection.
extension AppDelegate {

    func startOutsideAreaClickDetector() {
        detector = NSEvent.addGlobalMonitorForEvents(
                                                     matching: [NSEventMask.leftMouseDown,
                                                                NSEventMask.rightMouseDown],
                                                     handler: { [weak self] event in
            self?.closePopover()
        })
    }

    func stopOutsideAreaClickDetector() {
        if let temp = detector {
            NSEvent.removeMonitor(temp)
        }
    }

}
