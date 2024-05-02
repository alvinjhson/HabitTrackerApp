//
//  CalendarView.swift
//  HabitTrackerApp
//
//  Created by Alvin Johansson on 2024-04-30.
//

import Foundation
import SwiftUI

import SwiftUI

struct CalendarView: View {
    let daysInMonth: [Int]
    let firstDayOfMonth: Date
    
    init() {
        let currentCalendar = Calendar.current
        let currentDate = Date()
        let range = currentCalendar.range(of: .day, in: .month, for: currentDate)!
        
        daysInMonth = Array(1...range.count)
        
        var components = currentCalendar.dateComponents([.year, .month], from: currentDate)
        components.day = 1
        firstDayOfMonth = currentCalendar.date(from: components)!
    }
    
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(daysInMonth, id: \.self) { day in
                    Text("\(day)")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                      
                }
            }
        }
    }
}
#Preview {
   CalendarView()
}
