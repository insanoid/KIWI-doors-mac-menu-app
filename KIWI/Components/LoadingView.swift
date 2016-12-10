//
//  LoadingView.swift
//  KIWI
//
//  Created by Karthik on 10/12/16.
//  Copyright © 2016 Karthik. All rights reserved.
//

import Cocoa

enum LoadingState {
    case loading, error, empty, idle, noAuth, customState(String)
}

class LoadingView: NSView {

    @IBOutlet weak var loadingIndicator: NSProgressIndicator!
    @IBOutlet weak var loadingLabel: NSTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor
    }

    func showState(state: LoadingState) {
        switch state {
        case .loading:
            isHidden = false
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimation(nil)
            loadingLabel.stringValue = "Connecting your account..."

        case .error:
            isHidden = false
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimation(nil)
            loadingLabel.stringValue = "Something went wrong. Try again?"

        case .empty:
            isHidden = false
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimation(nil)
            loadingLabel.stringValue = "No sensors linked with this account."

        case .noAuth:
            isHidden = false
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimation(nil)
            loadingLabel.stringValue = "There are no credentials available, please update the settings."
        case .idle:
            isHidden = true
            loadingIndicator.stopAnimation(nil)
        case .customState(let message):
            isHidden = false
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimation(nil)
            loadingLabel.stringValue = message
        }
    }

    @IBAction func toggleReloadButton(sender: NSView) {
        showState(state: .loading)
    }
}
