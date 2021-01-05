//
//  ViewRequstCell.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 13.12.20.
//

import UIKit

class RequestListCell: UITableViewCell {

    @IBOutlet weak var vehicleInformation: UILabel!
    @IBOutlet weak var dateAndLocation: UILabel!
    @IBAction func viewDetailAction(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
