//
//  XCalendarPMonthYearPickerButton.swift
//  MultiDatePickerApp
//
//  Created by Aung Ko Min on 9/12/23.
//

import SwiftUI

struct XCalendarPMonthYearPickerButton: View {
    @EnvironmentObject var monthDataModel: XCalandarModel
    
    @Binding var isPresented: Bool
    
    var body: some View {
        Button {
            withAnimation {
                isPresented.toggle()
            }
        } label: {
            HStack {
                Text(monthDataModel.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(self.isPresented ? .accentColor : .primary)
                    .lineLimit(1)
                Image(systemName: "chevron.right")
                    .font(.system(size: 17))
                    .rotationEffect(self.isPresented ? .degrees(90) : .degrees(0))
            }
        }
    }
}

struct MonthYearPickerButton_Previews: PreviewProvider {
    static var previews: some View {
        XCalendarPMonthYearPickerButton(isPresented: .constant(false))
            .environmentObject(XCalandarModel())
    }
}
