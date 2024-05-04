//
//  CalendarView.swift
//  HabitTrackerApp
//
//  Created by Alvin Johansson on 2024-04-30.
//

import Foundation
import SwiftUI
import Firebase

import SwiftUI
//extension Date {
//    func isSameDay(as otherDate: Date) -> Bool {
//        let calendar = Calendar.current
//        return calendar.isDate(self, inSameDayAs: otherDate)
//    }
//}

struct CalendarView: View {
    @State private var streakDaysSet = Set<String>()
    let daysInMonth: [Int]
    let firstDayOfMonth: Date
    var habitId: String // Antag att du har ett sätt att identifiera vilken habit du vill hämta
   @State var dateFormatter = DateFormatter()
    
    
    init(daysInMonth: [Int], firstDayOfMonth: Date, habitId: String) {
        
        self.daysInMonth = daysInMonth
        self.firstDayOfMonth = firstDayOfMonth
        self.habitId = habitId
       // fetchStreakHistory()
       // print("hello working")
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
           
                    let dayDate = Calendar.current.date(bySetting: .day, value: day, of: firstDayOfMonth)!
                    let startOfDayDate = Calendar.current.startOfDay(for: dayDate)
                    
                    let dateString = dateFormatter.string(from: startOfDayDate)
                    let isStreakDay = streakDaysSet.contains(dateString)
                  
                    
                    Text("\(day)")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                        .background(isStreakDay ? Color.green : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }
            }
        }
        .onAppear {
             fetchStreakHistory()
         }
    }


    func fetchStreakHistory() {
        let db = Firestore.firestore()
        db.collection("habits").document(habitId).getDocument { (document, error) in
            if let streakHistory = document?.data()?["streakHistory"] as? [Timestamp] {
                print("Streak History: \(streakHistory)")
               // let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd" // Sätt formatet till år-månad-dag
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Ställ in tidszonen till UTC
                let dateStrings = streakHistory.map { timestamp -> String in
                    let date = timestamp.dateValue() // Konvertera Timestamp till Date
                    let dateString = dateFormatter.string(from: date) // Formatera Date till String och använd som datum utan tid
                    print("Formatted Date String: \(dateString)") // Lägg till denna rad för att se utskriften
                    
                    return dateString
                }
                print("Date Strings: \(dateStrings)")
                self.streakDaysSet = Set(dateStrings) // Använd Set för att hantera unika datumsträngar
                print("Streak Days Set: \(self.streakDaysSet)")
            } else {
                print("No streakHistory data found or wrong data type.")
            }
        }
    }

 
}
