//
//  XCalendarMonthYearPicker.swift
//  MultiDatePickerApp
//
//  Created by Aung Ko Min on 9/12/23.
//

import SwiftUI

struct XCalendarMonthYearPicker: View {
    let months = (0...11).map {$0}
    let years = (1970...2099).map {$0}
    
    var date: Date
    var action: (Int, Int) -> Void
    
    @State private var selectedMonth = 0
    @State private var selectedYear = 2020
    
    init(date: Date, action: @escaping (Int, Int) -> Void) {
        self.date = date
        self.action = action
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        self._selectedMonth = State(initialValue: month - 1)
        self._selectedYear = State(initialValue: year)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Picker("", selection: self.$selectedMonth) {
                ForEach(months, id: \.self) { month in
                    Text("\(Calendar.current.monthSymbols[month])")
                        .tag(month)
                }
            }
            .onChange(of: selectedMonth, { oldValue, newValue in
                self.action(newValue + 1, self.selectedYear)
            })
            .frame(width: 150)
            .clipped()
            
            Divider()
                .frame(height: 20)
                .foregroundColor(.accentColor)
            
            Picker("", selection: self.$selectedYear) {
                ForEach(years, id: \.self) { year in
                    Text(String(format: "%d", year))
                        .tag(year)
                }
            }
            .onChange(of: selectedYear, { oldValue, newValue in
                self.action(self.selectedMonth + 1, newValue)
            })
            .frame(width: 100)
            .clipped()
        }
        .padding(.bottom)
    }
}

struct MonthYearPicker_Previews: PreviewProvider {
    static var previews: some View {
        XCalendarMonthYearPicker(date: Date()) { (month, year) in
            print("You picked \(month), \(year)")
        }
        .frame(width: 300, height: 300)
    }
}
