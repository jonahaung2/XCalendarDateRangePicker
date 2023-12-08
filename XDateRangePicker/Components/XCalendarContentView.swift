//
//  XCalendarContentView.swift
//  MultiDatePickerApp
//
//  Created by Aung Ko Min on 9/12/23.
//

import SwiftUI
struct XCalendarContentView: View {
    @EnvironmentObject var monthDataModel: XCalandarModel

    let columns = Array<GridItem>(
        repeating: GridItem (.flexible(minimum: UIScreen.main.bounds.width * 0.045, maximum: UIScreen.main.bounds.width)),
        count: 7
    )
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(monthDataModel.dayNames, id: \.self) { name in
                Text(name.replacingOccurrences(of: ".", with: "").uppercased())
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 8)
            // The actual days of the month.
            ForEach(monthDataModel.days, id: \.day) { day in
                if day.day == 0 {
                    Text("")
                        .frame(minHeight:  UIScreen.main.bounds.width * 0.05, maxHeight:  UIScreen.main.bounds.width * 0.05)
                } else {
                    XCalanderDayView(dayOfMonth: day)
                }
            }
        }
        .padding([.bottom, .horizontal], 8)
    }
}

struct MonthContentView_Previews: PreviewProvider {
    static var previews: some View {
        XCalendarContentView()
            .environmentObject(XCalandarModel())
    }
}
