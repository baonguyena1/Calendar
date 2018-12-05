//
//  TestDragViewController.swift
//  Calendar
//
//  Created by Bao Nguyen on 12/5/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import DNDDragAndDrop
import QuartzCore

class TestDragViewController: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet var dropViews: [UIView]!
    var dragAndDropController: DNDDragAndDropController!
    
    fileprivate var myView: UIView {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let window = UIApplication.shared.delegate?.window, window != nil {
            
            self.dragAndDropController = DNDDragAndDropController(window: window!)
            self.dragAndDropController.registerDragSource(firstView, with: self)
            self.dropViews.forEach {
                self.dragAndDropController.registerDropTarget($0, with: self)
            }
        }
    }
    
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

}

extension TestDragViewController: DNDDragSourceDelegate {
    func draggingView(for operation: DNDDragOperation) -> UIView? {
        let view = snapshotOfCell(inputView: operation.dragSourceView)
        return view
    }
    
}

extension TestDragViewController: DNDDropTargetDelegate {
    func dragOperation(_ operation: DNDDragOperation, didDropInDropTarget target: UIView) {
        
    }
    
    func dragOperationWillCancel(_ operation: DNDDragOperation) {
        operation.removeDraggingViewAnimated(withDuration: 0.3) { (dragingView) in
            dragingView.alpha = 0.0
            dragingView.center = operation.convert(self.firstView.center, to: self.view)
        }
    }
    
    func dragOperation(_ operation: DNDDragOperation, didEnterDropTarget target: UIView) {
        target.layer.borderWidth = 2.0
        target.layer.borderColor = UIColor.red.cgColor
    }
    
    func dragOperation(_ operation: DNDDragOperation, didLeaveDropTarget target: UIView) {
        target.layer.borderWidth = 0.0
    }
}
