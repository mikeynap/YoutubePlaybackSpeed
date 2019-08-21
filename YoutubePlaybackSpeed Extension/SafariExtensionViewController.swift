//
//  SafariExtensionViewController.swift
//  YoutubePlaybackSpeed Extension
//
//  Created by Mike Napolitano on 8/20/19.
//  Copyright © 2019 mikeynap.dev. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
