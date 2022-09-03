//
//  SensorCell.swift
//  KIWI
//
//  Created by Karthik on 10/12/2016.
//  Copyright © 2016 Karthik. All rights reserved.
//

import Cocoa
import Foundation


/// Tableview cell to show information about the sensor.
class SensorCell: NSTableCellView {
    static var identifier = "sensorCellIdentifier"
    static var height = 55
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var taglineLabel: NSTextField!
    @IBOutlet weak var thumbnailImageView: NSImageView!

    private var sensor: Sensors?

    class func view(tableView: NSTableView,
                    owner: AnyObject?,
                    subject: AnyObject?) -> NSView? {
        if let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: SensorCell.identifier), owner: owner) as? SensorCell {
            if let sensor = subject as? Sensors {
                view.setCurrentSensor(sensor: sensor)
            }
            return view
        }
        return nil
    }

    private func setCurrentSensor(sensor: Sensors) {
        self.sensor = sensor
        updateUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        taglineLabel.textColor = NSColor.gray
        titleLabel.textColor = NSColor.black
    }

    func updateUI() {
        let invitePossible = sensor?.canInvite ?? false
        if let street = sensor?.address?.street {
            titleLabel.stringValue = street
        } else {
            titleLabel.stringValue = (sensor?.sensorUuid)!
        }
        if let city = sensor?.address?.city {
            taglineLabel.stringValue = city
        }
        if invitePossible {
            thumbnailImageView.image = NSImage.init(named: NSImage.statusAvailableName)
        } else {
            thumbnailImageView.image = NSImage.init(named: NSImage.statusUnavailableName)
        }
    }

}
