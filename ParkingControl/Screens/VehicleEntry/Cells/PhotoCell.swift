//
//  PhotoCell.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 9.12.20.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
        }
    

    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = .clear
        self.imageView.image = .remove
    }
}
