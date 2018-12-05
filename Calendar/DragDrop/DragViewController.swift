//
//  DragViewController.swift
//  Calendar
//
//  Created by Bao Nguyen on 12/4/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import DNDDragAndDrop

class DataItem : Equatable {
    
    var image: UIImage
    var index: Int
    
    init(image: UIImage, index: Int) {
        self.image = image
        self.index = index
    }
    
    static func ==(lhs: DataItem, rhs: DataItem) -> Bool {
        return lhs.index == rhs.index
    }
}

class DragViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var dragAndDropController: DNDDragAndDropController!
    
    fileprivate var data : [DataItem] = [DataItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.data = (0..<100).map { i in
            let image: UIImage = i % 3 == 0 ? #imageLiteral(resourceName: "ic_icon1") : #imageLiteral(resourceName: "ic_icon2")
            return DataItem(image: image, index: i)
        }
        if let window = UIApplication.shared.delegate?.window, window != nil {
            
            self.dragAndDropController = DNDDragAndDropController(window: window!)
        }
    }

}

extension DragViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HourReusableView.cellId, for: indexPath)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberViewCell.cellId, for: indexPath) as! MemberViewCell
        let data = self.data[indexPath.row]
        cell.avatarImageView.image = data.image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.row % 5 != 0
    }
}

extension DragViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 5.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension DragViewController: DNDDragSourceDelegate {
    
    func draggingView(for operation: DNDDragOperation) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.backgroundColor = UIColor.red
        return view
    }
    
    func dragOperationWillCancel(_ operation: DNDDragOperation) {
        operation.removeDraggingView()
    }
    
}

extension DragViewController: DNDDropTargetDelegate {
    func dragOperation(_ operation: DNDDragOperation, didDropInDropTarget target: UIView) {
        
    }
    
    func dragOperation(_ operation: DNDDragOperation, didEnterDropTarget target: UIView) {
        target.layer.borderColor = UIColor.red.cgColor
        target.layer.borderWidth = 1.0
    }
    
    func dragOperation(_ operation: DNDDragOperation, didLeaveDropTarget target: UIView) {
        target.layer.borderWidth = 0.0
    }
}
