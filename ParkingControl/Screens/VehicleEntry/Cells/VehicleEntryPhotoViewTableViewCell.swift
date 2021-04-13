//
//  VehicleEntryPhotoViewTableViewCell.swift
//  ParkingControl
//
//  Created by Mikalaj Shuhno on 3.12.20.
//

import UIKit
import CoreData

class VehicleEntryPhotoViewTableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: Properties
    var screenMode: VehicleEntryViewController.ScreenMode?
    var vehiclePhotoList: [UIImage?]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    weak var delegate: VehicleEntryViewControllerDelegate?
    
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
    
    // MARK: - Private interface
    private func tappedCamera() {
        guard let delegate = delegate else {
            print("Delegate VehicleEntryPhotoViewTableViewCell error")
            return
        }
        delegate.tappedCamera()
    }
}


// MARK: - UICollectionViewDataSourceDelegate
extension VehicleEntryPhotoViewTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch screenMode {
        case .view:
            return vehiclePhotoList?.count ?? 0
        case .edit:
            return (vehiclePhotoList?.count ?? 0) + 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PhotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath) as! VehicleEntryCollectionViewCell
        guard let vehiclePhotoList = vehiclePhotoList else {
            return cell
        }
        
        switch screenMode {
        case .view:
            let photo = vehiclePhotoList[indexPath.item]
            cell.imageView.image = photo
            cell.imageView.contentMode = .scaleToFill
            
            return cell
        case .edit:
            if indexPath.item == 0 {
                cell.backgroundColor = UIColor.gray
                cell.imageView.image = UIImage(systemName: "plus.circle",
                                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 50))
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
        default:
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch screenMode {
        case .edit:
            guard indexPath.item == 0 else {
                return
            }
            let cell = collectionView.cellForItem(at: indexPath) as! VehicleEntryCollectionViewCell
            cell.isSelected = true
            tappedCamera()
            print("pressed")
        default:
            break
        }
    }
}


