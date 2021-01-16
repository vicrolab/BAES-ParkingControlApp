//
//  SettingsTableViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 30.11.20.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBAction func logOutAction(_ sender: UIButton) {
        UserDefaults.standard.setValue(false, forKey: "status")
        Switcher.updateRootViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
    }
}
