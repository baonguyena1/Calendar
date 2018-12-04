//
//  DragViewController.swift
//  Calendar
//
//  Created by Bao Nguyen on 12/4/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import DNDDragAndDrop

class DragViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var dragAndDropController: DNDDragAndDropController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension DragViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 * 20
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HourReusableView.cellId, for: indexPath)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let myCell = cell as? MemberViewCell else {
            return
        }
        myCell.containerView.layer.cornerRadius = myCell.containerView.frame.width/2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberViewCell.cellId, for: indexPath) as! MemberViewCell
        cell.containerView.layer.cornerRadius = cell.containerView.frame.width/2.0
        
        self.dragAndDropController.registerDragSource(cell, with: self)
        self.dragAndDropController.registerDropTarget(cell, with: self)
        
        return cell
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
