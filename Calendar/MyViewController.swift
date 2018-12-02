//
//  MyViewController.swift
//  Calendar
//
//  Created by Bao Nguyen on 12/1/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import JTAppleCalendar

class MyViewController: UIViewController {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    fileprivate let myCalendar = Calendar(identifier: .gregorian)
    
    fileprivate lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    fileprivate lazy var cellSize: CGFloat = {
        return self.calendarView.frame.width / 7.0
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.cellSize = self.cellSize
        calendarView.minimumLineSpacing = 2
        calendarView.minimumInteritemSpacing = 2
    }

}

extension MyViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        self.formatter.dateFormat = "yyyy/MM/dd"
        let startDate = Date()
        let endDate = self.myCalendar.date(byAdding: .month, value: 1, to: startDate) ?? Date()
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                calendar: self.myCalendar,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .monday,
                                                hasStrictBoundaries: true)
        return parameter
    }

}

extension MyViewController: JTAppleCalendarViewDelegate {

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCell = cell as! CellView
        myCell.dayLabel.text = cellState.text
        configureVisibleCell(cell: cell, cellState: cellState, date: date)
    }

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: String(describing: CellView.self), for: indexPath) as! CellView
        cell.dayLabel.text = cellState.text
        configureVisibleCell(cell: cell, cellState: cellState, date: date)
        return cell
    }
    

    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: String(describing: SectionHeaderView.self), for: indexPath) as! SectionHeaderView
        
        let date = range.start
        self.formatter.dateFormat = "MMMM yyyy"
        let monthYear = self.formatter.string(from: date)
        header.yearLabel.text = monthYear
        return header
    }

    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 90)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        guard let myCell = cell as? CellView else { return false }
        if date < Date() {
            return false
        }
//        return myCell.cornerView.isHidden
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(cell: cell, cellState: cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(cell: cell, cellState: cellState, date: date)
    }
}

extension MyViewController {
    
    fileprivate func configureVisibleCell(cell: JTAppleCell, cellState: CellState, date: Date) {
        let myCell = cell as! CellView
        if self.myCalendar.isDateInToday(date) {
            myCell.borderView.backgroundColor = UIColor.red
        } else {
            myCell.borderView.backgroundColor = nil
        }
        if cellState.dateBelongsTo == .thisMonth {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }
        let isVisible: Bool = arc4random() % 2 == 0
        myCell.cornerView.isHidden = isVisible
    }
    
    fileprivate func handleCellSelection(cell: JTAppleCell?, cellState: CellState, date: Date) {
        guard let myCell = cell as? CellView else { return }
        
        if cellState.isSelected {
            myCell.borderView.backgroundColor = UIColor.green
        } else if self.myCalendar.isDateInToday(date) {
            myCell.borderView.backgroundColor = UIColor.red
        } else {
            myCell.borderView.backgroundColor = nil
        }
    }
}
