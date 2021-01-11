//
//  VehicleEntryTableViewCell.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 3.12.20.
//

import UIKit
import CoreData

class VehicleEntryTableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: Properties
    var screenMode: VehicleEntryViewController.ScreenMode?
    var vehiclePhotoList: [UIImage]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    var selectedVehicle: NSManagedObject?
    var delegate: VehicleEntryViewControllerDelegate?
    
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        screenMode = .edit
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Setup
    
    
    // MARK: - Public interface
    func tappedCamera() {
        delegate?.tappedCamera()
    }
    
    // MARK: - Private interface
}


// MARK: - UICollectionViewDataSourceDelegate
extension VehicleEntryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if screenMode == .view {
            guard let vehiclePhotoList = vehiclePhotoList
            else {
                return 0
            }
            return vehiclePhotoList.count
        }
        if screenMode == .edit {
            guard let vehiclePhotoList = vehiclePhotoList
            else {
                return 0
            }
            return vehiclePhotoList.count + 1
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PhotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! VehicleEntryCollectionViewCell
        guard let vehiclePhotoList = vehiclePhotoList
        else {
            return cell
        }
        
        if screenMode == .view {
            let photo = vehiclePhotoList[indexPath.item]
            cell.imageView.image = photo
            cell.imageView.contentMode = .scaleToFill
            
            return cell
        } else {
            if indexPath.item == 0 {
                cell.backgroundColor = UIColor.gray
                cell.imageView.image = UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50))
                cell.imageView.tintColor = UIColor.white
                cell.imageView.contentMode = .center
                
                return cell
            }
            let photo = vehiclePhotoList[indexPath.item - 1]
            cell.imageView.image = photo
            cell.imageView.contentMode = .scaleToFill
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.lightGray.cgColor
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if screenMode == .edit {
            let cell = collectionView.cellForItem(at: indexPath) as! VehicleEntryCollectionViewCell
            cell.isSelected = true
            tappedCamera()
            print("pressed")
        }
    }
}


