//
//  ViewController.swift
//  YoutubePlaybackSpeed
//
//  Created by Mike Napolitano on 8/20/19.
//  Copyright © 2019 mikeynap.dev. All rights reserved.
//

import Cocoa
import SafariServices.SFSafariApplication

class ViewController: NSViewController {

    @IBOutlet var appNameLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openSafariExtensionPreferences(_ sender: AnyObject?) {
        SFSafariApplication.showPreferencesForExtension(withIdentifier: "dev.mikeynap.YoutubePlaybackSpeed-Extension") { error in
            if let _ = error {
                // Insert code to inform the user that something went wrong.

            }
        }
    }

}
