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
    
    fileprivate lazy var longPressGesture: DNDLongPressDragRecognizer = {
        let gesture = DNDLongPressDragRecognizer()
        gesture.minimumPressDuration = 0.01
        return gesture
    }()
    
    fileprivate var data : [DataItem] = [DataItem]()
    
    fileprivate var sourceIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.data = (0..<100).map { i in
            let image: UIImage = i % 3 == 0 ? #imageLiteral(resourceName: "ic_icon1") : #imageLiteral(resourceName: "ic_icon2")
            return DataItem(image: image, index: i)
        }
        if let window = UIApplication.shared.delegate?.window, window != nil {
            
            self.dragAndDropController = DNDDragAndDropController(window: window!)
            let gesture = DNDLongPressDragRecognizer()
            gesture.minimumPressDuration = 0.5
            
            self.collectionView.panGestureRecognizer.require(toFail: gesture)
            
            self.dragAndDropController.registerDragSource(self.collectionView, with: self, drag: gesture)
            self.dragAndDropController.registerDropTarget(self.collectionView, with: self)
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
    
    fileprivate func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        cellSnapshot.isUserInteractionEnabled = true
        cellSnapshot.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return cellSnapshot
    }

    
    func draggingView(for operation: DNDDragOperation) -> UIView? {
        
        guard let indexPath = self.collectionView.indexPathForItem(at: operation.location(in: self.collectionView)) else { return nil }
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? MemberViewCell else { return nil }
        self.sourceIndexPath = indexPath
        print("didDropInDropTarget: \(indexPath.row) - \(indexPath.section)")
        let view = snapshotOfCell(inputView: cell.containerView)
        return view
    }
    
    func dragOperationWillCancel(_ operation: DNDDragOperation) {
        operation.removeDraggingView()
    }
    
}

extension DragViewController: DNDDropTargetDelegate {
    func dragOperation(_ operation: DNDDragOperation, didDropInDropTarget target: UIView) {
        
        defer {
            operation.removeDraggingView()
        }
        guard let indexPath = self.collectionView.indexPathForItem(at: operation.location(in: self.collectionView)) else { return }
        print("didDropInDropTarget: \(indexPath.row) - \(indexPath.section)")
    }
    
    func dragOperation(_ operation: DNDDragOperation, didEnterDropTarget target: UIView) {
        print("didEnterDropTarget")
        guard let indexPath = self.collectionView.indexPathForItem(at: operation.location(in: self.collectionView)) else { return }
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? MemberViewCell else { return }
        
        cell.containerView.layer.borderColor = UIColor.red.cgColor
        cell.containerView.layer.borderWidth = 2.0
    }
    
    func dragOperation(_ operation: DNDDragOperation, didLeaveDropTarget target: UIView) {
        print("didLeaveDropTarget")
        guard let indexPath = self.collectionView.indexPathForItem(at: operation.location(in: self.collectionView)) else { return }
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? MemberViewCell else { return }
        cell.containerView.layer.borderWidth = 0.0
    }
}
