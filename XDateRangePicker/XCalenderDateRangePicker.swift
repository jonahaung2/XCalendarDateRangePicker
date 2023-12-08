//
//  XCalenderDateRangePicker.swift
//  MultiDatePickerApp
//
//  Created by Aung Ko Min on 9/12/23.
//

import SwiftUI

public struct XCalenderDateRangePicker: View {
    public enum XCalendarPickerType {
        case singleDay
        case anyDays
        case dateRange
    }

    public enum DateSelectionChoices {
        case allDays
        case weekendsOnly
        case weekdaysOnly
    }

    @StateObject var monthModel: XCalandarModel
    public init(singleDay: Binding<Date>,
                includeDays: DateSelectionChoices = .allDays,
                minDate: Date? = nil,
                maxDate: Date? = nil
    ) {
        _monthModel = StateObject(wrappedValue: XCalandarModel(singleDay: singleDay, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
    }

    public init(anyDays: Binding<[Date]>,
                includeDays: DateSelectionChoices = .allDays,
                minDate: Date? = nil,
                maxDate: Date? = nil
    ) {
        _monthModel = StateObject(wrappedValue: XCalandarModel(anyDays: anyDays, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
    }


    public init(dateRange: Binding<ClosedRange<Date>?>,
                includeDays: DateSelectionChoices = .allDays,
                minDate: Date? = nil,
                maxDate: Date? = nil
    ) {
        _monthModel = StateObject(wrappedValue: XCalandarModel(dateRange: dateRange, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
    }

    public var body: some View {
        XCalendarMonthView()
            .environmentObject(monthModel)
    }
}
