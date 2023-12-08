//
//  XCalendarMonthView.swift
//  MultiDatePickerApp
//
//  Created by Aung Ko Min on 9/12/23.
//

import SwiftUI

struct XCalendarMonthView: View {
    @EnvironmentObject var monthDataModel: XCalandarModel
    
    @State private var showMonthYearPicker = false
    @State private var testDate = Date()
    
    private func showPrevMonth() {
        withAnimation {
            monthDataModel.decrMonth()
            showMonthYearPicker = false
        }
    }
    
    private func showNextMonth() {
        withAnimation {
            monthDataModel.incrMonth()
            showMonthYearPicker = false
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                XCalendarPMonthYearPickerButton(isPresented: $showMonthYearPicker)
                Spacer()
                
                Button {
                    showPrevMonth()
                } label: {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.title2)
                }
                .padding()
                
                Button {
                    showNextMonth()
                } label: {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.title2)
                }
                .padding()
            }
            .padding(.leading, 18)
            
            if showMonthYearPicker {
                XCalendarMonthYearPicker(date: monthDataModel.controlDate) { (month, year) in
                    self.monthDataModel.show(month: month, year: year)
                }
                .padding(.horizontal)
            }
            else {
                XCalendarContentView()
            }
        }
      
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        XCalendarMonthView()
            .environmentObject(XCalandarModel())
    }
}
