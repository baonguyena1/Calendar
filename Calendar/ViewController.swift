//
//  ViewController.swift
//  Calendar
//
//  Created by Bao Nguyen on 11/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    fileprivate lazy var gregorian: Calendar = {
        return Calendar(identifier: .gregorian)
    }()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.scrollDirection = .vertical
        calendar.placeholderType = .none
        calendar.appearance.headerDateFormat = "MMM YYYY"
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        calendar.register(EventCell.self, forCellReuseIdentifier: "eventCell")
    
    }
}

extension ViewController: FSCalendarDataSource {
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.dateFormatter.date(from: "2018-01-01") ?? Date()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.dateFormatter.date(from: "2020-01-01") ?? Date()
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "eventCell", for: date, at: position)
        return cell
    }
}
