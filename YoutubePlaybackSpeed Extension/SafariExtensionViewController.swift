//
//  SafariExtensionViewController.swift
//  YoutubeSpeedExtension
//
//  Created by Mike Napolitano on 8/17/19.
//  Copyright © 2019 mikeynap.dev. All rights reserved.
//

import SafariServices

// I didn't know how to do proper bindings... so
// we have this beautiful display of early 2000s cocoa.

class SafariExtensionViewController: SFSafariExtensionViewController {
    @IBOutlet weak var tableView:NSTableView!
    @IBOutlet weak var enabledButton:NSButton!
    static let untitledTableViewData =  [
            "username" : "channel name",
            "playbackSpeed" : "1.0"
    ]
    static let defaultTableViewData =  [
            "username" : "*",
            "playbackSpeed" : "1.0"
    ]

    
    var tableViewData: [[String:String]] = []
    
    static func isEnabled() -> Bool {
        let enabled = UserDefaults.standard.integer(forKey: "enabled");
        return enabled != -1;
    }

    static func data() -> [String:Float] {
        var userData: [String:Float] = [:]
        if !isEnabled() {
            return userData
        }
        if let storedData =  UserDefaults.standard.array(forKey: "tableViewData") as? [[String: String]] {
            for d in storedData {
                if let speed = Float(d["playbackSpeed"]!){
                    userData[d["username"]!.lowercased()] = speed
                }
            }
        }
        return userData
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.beginUpdates()
        if let tvd = UserDefaults.standard.array(forKey: "tableViewData") as? [[String: String]] {
            for row in tvd {
                add(row)
            }
        } else {
            add(SafariExtensionViewController.defaultTableViewData)
        }
        tableView.endUpdates()

        enabledButton.state = SafariExtensionViewController.isEnabled() ? NSControl.StateValue.on : NSControl.StateValue.off;
    }

    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:335, height:274)
        return shared
    }()
    
    @IBAction func add(_ sender: Any) {
        let indexSet = tableViewData.count
        tableView.beginUpdates()
        if (sender is [String:String]) {
            tableViewData.append(sender as! [String:String])
        } else {
            tableViewData.append(SafariExtensionViewController.untitledTableViewData);
        }
        tableView.insertRows(at: [indexSet], withAnimation: .effectFade);
        tableView.scrollRowToVisible(indexSet)  // scroll to where it is
        tableView.selectRowIndexes([indexSet], byExtendingSelection: false)  // select it
        tableView.endUpdates()
    
        
    }
    @IBAction func delete(_ sender: Any) {
        if self.tableView.selectedRowIndexes.count == 0 {
            return;
        }
        
        if let removeIndex = tableView.selectedRowIndexes.first {
            tableView.beginUpdates();
            tableViewData.remove(at: removeIndex);
            tableView.removeRows(at: [removeIndex])
            tableView.endUpdates();
            UserDefaults.standard.set(tableViewData, forKey: "tableViewData")
        }

    }
    
    @IBAction func toggledEnable(_ sender: Any) {
        let enabledBox = sender as! NSButton
        UserDefaults.standard.set(enabledBox.state == NSControl.StateValue.on ? 1 : -1, forKey: "enabled");
    }
}


extension SafariExtensionViewController:NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int)
        -> NSView? {
            if (tableColumn?.identifier == nil){
                return nil
            }
            if (tableViewData.count <= row) {
                return nil
            }
            let item = tableViewData[row]
            let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
            cell?.textField?.isEditable = true;
            cell?.textField?.identifier = (tableColumn!.identifier);
            cell?.textField?.stringValue = item[(tableColumn?.identifier.rawValue)!]!
            cell?.textField?.delegate = self;
            return cell;
    }
    
     func controlTextDidEndEditing(_ notification: Notification) {
        if let textField = notification.object as? NSTextField {
            if textField.superview == nil || textField.identifier == nil {
                return
            }
            
            let row = tableView.row(for: textField.superview!)
            tableViewData[row][(textField.identifier?.rawValue)!] = textField.stringValue
            UserDefaults.standard.set(tableViewData, forKey: "tableViewData")
        }
    }
}
