//
//  PhotoCell.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 9.12.20.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    
//    static var photos = [
//        UIImage.init(named: "image1"),
//        UIImage.init(named: "image2"),
//        UIImage.init(named: "image3")
//    ]
    
    override func awakeFromNib() {
            super.awakeFromNib()
        }
    

    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = .clear
    }
}
