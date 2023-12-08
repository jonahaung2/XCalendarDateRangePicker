//
//  ContentView.swift
//  XDateRangePicker
//
//  Created by Aung Ko Min on 9/12/23.
//

import SwiftUI

struct ContentView: View {

    // The MultiDatePicker can be used to select a single day, multiple days, or a date range. These
    // vars are used as bindings passed to the MultiDatePicker.
    @State private var selectedDate = Date()
    @State private var anyDays = [Date]()
    @State private var dateRange: ClosedRange<Date>? = nil

    // Another thing you can do with the MultiDatePicker is limit the range of dates that can
    // be selected.
    let testMinDate = Calendar.current.date(from: DateComponents(year: 2021, month: 4, day: 1))
    let testMaxDate = Calendar.current.date(from: DateComponents(year: 2021, month: 5, day: 30))

    // Used to toggle an overlay containing a MultiDatePicker.
    @State private var showOverlay = false

    var selectedDateAsString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }

    var body: some View {
        TabView {

            // Here's how to select a single date, but limiting the range of dates than be picked.
            // The binding (selectedDate) will be whatever date is currently picked.
            VStack {
                Text("Single Day").font(.title).padding()
                XCalenderDateRangePicker(
                    singleDay: self.$selectedDate,
                    minDate: testMinDate,
                    maxDate: testMaxDate)
                Text(selectedDateAsString).padding()
            }
            .tabItem {
                Image(systemName: "1.circle")
                Text("Single")
            }

            // Here's how to select multiple, non-contiguous dates. Tapping on a date will
            // toggle its selection. The binding (anyDays) will be an array of zero or
            // more dates, sorted in ascending order. In this example, the selectable dates
            // are limited to weekdays.
            VStack {
                Text("Any Dates").font(.title).padding()
                XCalenderDateRangePicker(anyDays: self.$anyDays, includeDays: .weekdaysOnly)
                Text("Selected \(anyDays.count) Days").padding()
            }
            .tabItem {
                Image(systemName: "n.circle")
                Text("Any")
            }

            // Here's how to select a date range. Initially the range is nil. Tapping on
            // a date makes it the first date in the range, but the binding (dateRange) is
            // still nil. Tapping on another date completes the range and sets the binding.
            VStack {
                Text("Date Range").font(.title).padding()
                XCalenderDateRangePicker(dateRange: self.$dateRange)
                if let range = dateRange {
                    Text("\(range)").padding()
                } else {
                    Text("Select two dates").padding()
                }
            }
            .tabItem {
                Image(systemName: "ellipsis.circle")
                Text("Range")
            }

            // Here's how to put the MultiDatePicker into a pop-over/dialog using
            // the .overlay modifier (see below).
            VStack {
                Text("Pop-Over").font(.title).padding()
                Button("Selected \(anyDays.count) Days") {
                    withAnimation {
                        self.showOverlay.toggle()
                    }
                }.padding()
            }
            .tabItem {
                Image(systemName: "square.stack.3d.up")
                Text("Overlay")
            }
        }
        .onChange(of: selectedDate, { oldValue, newValue in
            print("Single date selected: \(newValue)")
        })
        .onChange(of: anyDays, { oldValue, newValue in
            print(newValue)
        })
        .onChange(of: dateRange, { oldValue, newValue in
            print(newValue)
        })
        .blur(radius: showOverlay ? 6 : 0)
        .overlay(
            ZStack {
                if self.showOverlay {
                    Color.black.opacity(0.25)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                self.showOverlay.toggle()
                            }
                        }
                    XCalenderDateRangePicker(dateRange: $dateRange)
                        .padding(8)
                        .background()
                        .cornerRadius(16)
                        .padding()
                }
            }
        )
    }
}

#Preview {
    ContentView()
}
