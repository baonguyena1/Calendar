//
//  CellView.swift
//  Calendar
//
//  Created by Bao Nguyen on 12/1/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import JTAppleCalendar

class CellView: JTAppleCell {
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var cornerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.borderView.layer.cornerRadius = 6.0
        self.borderView.layer.masksToBounds = true
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = UIColor.red.cgColor
        
        self.cornerView.layer.cornerRadius = 8.0
        self.cornerView.layer.masksToBounds = true
    }
    
}
