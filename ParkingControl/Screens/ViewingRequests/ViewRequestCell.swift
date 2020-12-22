//
//  ViewRequstCell.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 13.12.20.
//

import UIKit

class ViewRequestCell: UITableViewCell {

    @IBOutlet weak var vehicleInformation: UILabel!
    @IBOutlet weak var dateAndLocation: UILabel!
    @IBAction func viewDetail(_ sender: UIButton) {
    }
    
    var carsStore = CarsStore()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
