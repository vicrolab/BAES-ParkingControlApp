//
//  VehicleEntryTableViewCell.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 3.12.20.
//

import UIKit

class VehicleEntryTableViewCell: UITableViewCell, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate,
                                             forRow row: Int) {
        collectionView.dataSource = dataSourceDelegate
        collectionView.delegate = dataSourceDelegate
        collectionView.reloadData()
    }
    
    func updateArray() {
        collectionView.reloadData()
    }
}



