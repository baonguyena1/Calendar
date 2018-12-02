//
//  Date+Helper.swift
//  Calendar
//
//  Created by Bao Nguyen on 12/2/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

extension Date {
    
    func compareWithOutTime(date: Date) -> ComparisonResult {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let currentDateString = formatter.string(from: self)
        let compareDateString = formatter.string(from: date)
        return currentDateString.compare(compareDateString)
    }
}
