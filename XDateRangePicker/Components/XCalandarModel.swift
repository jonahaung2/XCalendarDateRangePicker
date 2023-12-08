//
//  XCalandarModel.swift
//  MultiDatePickerApp
//
//  Created by Aung Ko Min on 9/12/23.
//

import SwiftUI
import Combine

class XCalandarModel: NSObject, ObservableObject {
    public var controlDate: Date = Date() {
        didSet {
            buildDays()
        }
    }
    @Published var days = [XCalendarDayOfMonth]()
    @Published var title = ""
    @Published var selections = [Date]()
    let dayNames = Calendar.current.shortWeekdaySymbols

    private var singleDayWrapper: Binding<Date>?
    private var anyDatesWrapper: Binding<[Date]>?
    private var dateRangeWrapper: Binding<ClosedRange<Date>?>?
    
    private var minDate: Date? = nil
    private var maxDate: Date? = nil

    private var pickerType: XCalenderDateRangePicker.XCalendarPickerType = .dateRange
    private var selectionType: XCalenderDateRangePicker.DateSelectionChoices = .allDays
    private var numDays = 0

    convenience init(anyDays: Binding<[Date]>,
                     includeDays: XCalenderDateRangePicker.DateSelectionChoices,
                     minDate: Date?,
                     maxDate: Date?) {
        self.init()
        self.anyDatesWrapper = anyDays
        self.selectionType = includeDays
        self.minDate = minDate
        self.maxDate = maxDate
        setSelection(anyDays.wrappedValue)

        if let useDate = anyDays.wrappedValue.first {
            controlDate = useDate
        }
        buildDays()
    }
    
    convenience init(singleDay: Binding<Date>,
                     includeDays: XCalenderDateRangePicker.DateSelectionChoices,
                     minDate: Date?,
                     maxDate: Date?) {
        self.init()
        self.singleDayWrapper = singleDay
        self.selectionType = includeDays
        self.minDate = minDate
        self.maxDate = maxDate
        setSelection(singleDay.wrappedValue)
        
        // set the controlDate to be this singleDay
        controlDate = singleDay.wrappedValue
        buildDays()
    }
    
    convenience init(dateRange: Binding<ClosedRange<Date>?>,
                     includeDays: XCalenderDateRangePicker.DateSelectionChoices,
                     minDate: Date?,
                     maxDate: Date?) {
        self.init()
        self.dateRangeWrapper = dateRange
        self.selectionType = includeDays
        self.minDate = minDate
        self.maxDate = maxDate
        setSelection(dateRange.wrappedValue)
        
        // set the selection to be the first in the range if the range exists
        if let dateRange = dateRange.wrappedValue {
            controlDate = dateRange.lowerBound
        }
        buildDays()
    }

    func dayOfMonth(byDay: Int) -> XCalendarDayOfMonth? {
        guard 1 <= byDay && byDay <= 31 else { return nil }
        for dom in days {
            if dom.day == byDay {
                return dom
            }
        }
        return nil
    }
    
    func selectDay(_ day: XCalendarDayOfMonth) {
        guard day.isSelectable else { return }
        guard let date = day.date else { return }
        
        switch pickerType {

        case .singleDay:
            selections = [date]
            singleDayWrapper?.wrappedValue = date
        case .anyDays:
            if selections.contains(date), let pos = selections.firstIndex(of: date) {
                selections.remove(at: pos)
            } else {
                selections.append(date)
            }
            selections.sort()
            anyDatesWrapper?.wrappedValue = selections
        default:
            if selections.count != 1 {
                selections = [date]
            } else {
                selections.append(date)
            }
            selections.sort()
            if selections.count == 2 {
                dateRangeWrapper?.wrappedValue = selections[0]...selections[1]
            } else {
                dateRangeWrapper?.wrappedValue = nil
            }
        }
    }
    
    func isSelected(_ day: XCalendarDayOfMonth) -> Bool {
        guard day.isSelectable else { return false }
        guard let date = day.date else { return false }
        
        if pickerType == .anyDays || pickerType == .singleDay {
            for test in selections {
                if isSameDay(date1: test, date2: date) {
                    return true
                }
            }
        } else {
            if selections.count == 0 {
                return false
            }
            else if selections.count == 1 {
                return isSameDay(date1: selections[0], date2: date)
            } else {
                let range = selections[0]...selections[1]
                return range.contains(date)
            }
        }
        return false
    }
    
    func incrMonth() {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: 1, to: controlDate) {
            controlDate = newDate
        }
    }
    
    func decrMonth() {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: -1, to: controlDate) {
            controlDate = newDate
        }
    }
    
    func show(month: Int, year: Int) {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: 1)
        if let newDate = calendar.date(from: components) {
            controlDate = newDate
        }
    }
    
}

// MARK: - BUILD DAYS

extension XCalandarModel {
    
    private func buildDays() {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: controlDate)
        let month = calendar.component(.month, from: controlDate)
        
        let dateComponents = DateComponents(year: year, month: month)
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        let ord = calendar.component(.weekday, from: date)
        var index = 0
        
        let today = Date()

        var daysArray = [XCalendarDayOfMonth]()
        for _ in 1..<ord {
            daysArray.append(XCalendarDayOfMonth(index: index, day: 0))
            index += 1
        }
        for i in 0..<numDays {
            let realDate = calendar.date(from: DateComponents(year: year, month: month, day: i+1))
            var dom = XCalendarDayOfMonth(index: index, day: i+1, date: realDate)
            dom.isToday = isSameDay(date1: today, date2: realDate)
            dom.isSelectable = isEligible(date: realDate)
            daysArray.append(dom)
            index += 1
        }
        let total = daysArray.count
        var remainder = 42 - total
        if remainder < 0 {
            remainder = 42 - total
        }
        
        for _ in 0..<remainder {
            daysArray.append(XCalendarDayOfMonth(index: index, day: 0))
            index += 1
        }
        self.numDays = numDays
        self.title = "\(calendar.monthSymbols[month-1]) \(year)"
        self.days = daysArray
    }
}
extension XCalandarModel {
    
    private func setSelection(_ date: Date) {
        pickerType = .singleDay
        selections = [date]
    }
    
    private func setSelection(_ anyDates: [Date]) {
        pickerType = .anyDays
        selections = anyDates.map { $0 }
    }
    
    private func setSelection(_ dateRange: ClosedRange<Date>?) {
        pickerType = .dateRange
        if let dateRange = dateRange {
            selections = [dateRange.lowerBound, dateRange.upperBound]
        }
    }
    
    private func isSameDay(date1: Date?, date2: Date?) -> Bool {
        guard let date1 = date1, let date2 = date2 else { return false }
        let day1 = Calendar.current.component(.day, from: date1)
        let day2 = Calendar.current.component(.day, from: date2)
        let year1 = Calendar.current.component(.year, from: date1)
        let year2 = Calendar.current.component(.year, from: date2)
        let month1 = Calendar.current.component(.month, from: date1)
        let month2 = Calendar.current.component(.month, from: date2)
        return (day1 == day2) && (month1 == month2) && (year1 == year2)
    }
    
    private func isEligible(date: Date?) -> Bool {
        guard let date = date else { return true }
                
        if let minDate = minDate, let maxDate = maxDate {
            return (minDate...maxDate).contains(date)
        } else if let minDate = minDate {
            return date >= minDate
        } else if let maxDate = maxDate {
            return date <= maxDate
        }
        
        switch selectionType {
        case .weekendsOnly:
            let ord = Calendar.current.component(.weekday, from: date)
            return ord == 1 || ord == 7
        case .weekdaysOnly:
            let ord = Calendar.current.component(.weekday, from: date)
            return 1 < ord && ord < 7
        default:
            return true
        }
    }
}
