//
//  XCalanderDayView.swift
//  MultiDatePickerApp
//
//  Created by Aung Ko Min on 9/12/23.
//

import SwiftUI

struct XCalanderDayView: View {
    @EnvironmentObject var monthDataModel: XCalandarModel
    let cellSize: CGFloat = 30 // FIXME: MAKE DYNAMIC
    var dayOfMonth: XCalendarDayOfMonth
    
    // outline "today"
    private var strokeColor: Color {
        dayOfMonth.isToday ? .yellow : .clear
    }

    private var fillColor: Color {
        monthDataModel.isSelected(dayOfMonth) ? .accentColor : .clear
    }
    private var textColor: Color {
        if dayOfMonth.isSelectable {
            return monthDataModel.isSelected(dayOfMonth) ? .white : .primary
        } else {
            return Color.gray
        }
    }
    
    private func handleSelection() {
        if dayOfMonth.isSelectable {
            monthDataModel.selectDay(dayOfMonth)
        }
    }
    
    var body: some View {
        Button {
            handleSelection()
        } label: {
            Text("\(dayOfMonth.day)")
                .font(.headline)
                .foregroundColor(textColor)
                .frame(minHeight: cellSize, maxHeight: cellSize)
                .background(
                    Circle()
                        .stroke(strokeColor, lineWidth: 1)
                        .background(Circle().foregroundColor(fillColor))
                        .frame(width: cellSize, height: cellSize)
                )
        }
        .foregroundColor(.black)
    }
}

struct DayOfMonthView_Previews: PreviewProvider {
    static var previews: some View {
        XCalanderDayView(dayOfMonth: XCalendarDayOfMonth(index: 0, day: 1, date: Date(), isSelectable: true, isToday: false))
            .environmentObject(XCalandarModel())
    }
}
