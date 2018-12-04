//
//  MemberViewCell.swift
//  Calendar
//
//  Created by Bao Nguyen on 12/4/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class MemberViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        containerView.layer.cornerRadius = containerView.frame.width/2.0
    }
    
    static var cellId: String {
        return String(describing: MemberViewCell.self)
    }
}
