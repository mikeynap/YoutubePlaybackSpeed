//
//  SafariExtensionHandler.swift
//  YoutubeSpeedExtension
//
//  Created by Mike Napolitano on 8/17/19.
//  Copyright © 2019 mikeynap.dev. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
        }
        
        // use value from NSDefaults incase view hasn't loaded yet...
        //NSLog("\(popoverViewController().data())")
        page.dispatchMessageToScript(withName: "data", userInfo: SafariExtensionViewController.data());
    }
    
    override func popoverDidClose(in window: SFSafariWindow) {
        let data = SafariExtensionViewController.data();
        window.getAllTabs { (tabs) in
            for tab in tabs {
                tab.getPagesWithCompletionHandler { (pages) in
                    if pages == nil {
                        return;
                    }
                    for page in pages! {
                        page.dispatchMessageToScript(withName: "data", userInfo: data);
                    }
                }
            }
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        // This method will be called when your toolbar item is clicked.
        NSLog("The extension's toolbar item was clicked")
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SafariExtensionViewController {
        return SafariExtensionViewController.shared
    }
}
