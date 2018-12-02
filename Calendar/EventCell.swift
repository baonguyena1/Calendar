//
//  EventCell.swift
//  Calendar
//
//  Created by Bao Nguyen on 11/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import FSCalendar

class EventCell: FSCalendarCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init!(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func commonInit() {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 6)
        shapeLayer.frame = bounds
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
    }
}
