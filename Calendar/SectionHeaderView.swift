//
//  SectionHeaderView.swift
//  Calendar
//
//  Created by Bao Nguyen on 12/2/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import JTAppleCalendar

class SectionHeaderView: JTAppleCollectionReusableView {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var weekDayStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
