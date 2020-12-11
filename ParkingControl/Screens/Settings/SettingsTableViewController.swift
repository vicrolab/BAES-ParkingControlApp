//
//  SettingsTableViewController.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 30.11.20.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBAction func buttonLogOut(_ sender: UIButton) {
        
        UserDefaults.standard.setValue(false, forKey: "status")
        Switcher.updateRootVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    

}
