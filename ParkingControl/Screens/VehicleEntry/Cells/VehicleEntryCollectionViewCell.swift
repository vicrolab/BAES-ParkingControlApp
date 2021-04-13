//
//  VehicleEntryCollectionViewCell.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 9.12.20.
//

import UIKit

class VehicleEntryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    

    override func prepareForReuse() {
        super.prepareForReuse()

        backgroundColor = .clear
        imageView.image = .remove
    }
}
