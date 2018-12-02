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
        calendarView.deselectAllDates()
    }

}

extension MyViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        self.formatter.dateFormat = "yyyy/MM/dd"
        let startDate = Date()
        let endDate = self.myCalendar.date(byAdding: .year, value: 1, to: startDate) ?? Date()
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                calendar: self.myCalendar,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfRow,
                                                firstDayOfWeek: .sunday,
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
        return MonthSize(defaultSize: 80)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        self.formatter.dateFormat = "yyyy/MM/dd"
        let dateString = self.formatter.string(from: date)
        let currentDate = self.formatter.string(from: Date())
        if dateString < currentDate || cellState.dateBelongsTo != .thisMonth {
            return false
        }
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
        
        if cellState.dateBelongsTo == .thisMonth {
            myCell.dayLabel.text = cellState.text
        } else {
            myCell.dayLabel.text = nil
        }
        handleDisableCell(cell: myCell, cellState: cellState)
        handleShowTag(cell: myCell, cellState: cellState)
    }
    
    fileprivate func handleDisableCell(cell: CellView, cellState: CellState) {
        self.formatter.dateFormat = "yyyy/MM/dd"
        let dateString = self.formatter.string(from: cellState.date)
        let currentDate = self.formatter.string(from: Date())
        if dateString < currentDate || cellState.dateBelongsTo != .thisMonth {
            cell.borderView.layer.borderWidth = 0.0
            cell.borderView.backgroundColor = UIColor.disable
            cell.dayLabel.textColor = UIColor.disableText
        } else {
            cell.borderView.layer.borderWidth = 1.0
            cell.borderView.backgroundColor = UIColor.white
            cell.dayLabel.textColor = UIColor.selected
        }
    }
    
    fileprivate func handleShowTag(cell: CellView, cellState: CellState) {
        self.formatter.dateFormat = "yyyy/MM/dd"
        let dateString = self.formatter.string(from: cellState.date)
        let currentDate = self.formatter.string(from: Date())
        if dateString < currentDate || cellState.dateBelongsTo != .thisMonth {
            cell.cornerView.isHidden = true
        } else {
            let isVisible = arc4random() % 2 == 0
            cell.cornerView.isHidden = isVisible
        }
    }
    
    fileprivate func handleCellSelection(cell: JTAppleCell?, cellState: CellState, date: Date) {
        guard let myCell = cell as? CellView else { return }
        
        if cellState.isSelected {
            myCell.borderView.backgroundColor = UIColor.selected
            myCell.dayLabel.textColor = UIColor.deSelected
        } else {
            myCell.borderView.backgroundColor = UIColor.deSelected
            myCell.dayLabel.textColor = UIColor.selected
        }
    }
}
