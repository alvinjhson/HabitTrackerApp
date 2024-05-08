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
struct Habit {
    var id: String
    var habitName: String
  
}


struct CalendarView: View {
    @State private var streakDaysSet = Set<String>()
    let daysInMonth: [Int]
    let firstDayOfMonth: Date
 
    @State var habitId: String = "ppen7o0pDwowGa88P8Q8"
    @State var dateFormatter = DateFormatter()
    @State var daysToShow = [Int]()
    @State var habits: [Habit] = []
    @State var selectedHabitId: String = ""
    @State var currentStreak: Int = 0
    @State var highestStreak: Int = 0
    @State var habitName: String = ""
    
    //test
    
    
    
    init(daysInMonth: [Int], firstDayOfMonth: Date, habitId: String) {
       
        self.daysInMonth = daysInMonth
        self.firstDayOfMonth = firstDayOfMonth
        self.habitId = habitId
       

        print("Initierar med första dagen i månaden: \(firstDayOfMonth)")
    }
    
    
    
    var body: some View {
        VStack {
             Picker("Välj habit", selection: $selectedHabitId) {
                 ForEach(habits, id: \.id) { habit in
                     Text(habit.habitName)
                 }
             }
             .pickerStyle(SegmentedPickerStyle())
             .onChange(of: selectedHabitId) { newValue in
                habitId = newValue
                 fetchStreakHistory()
                 showRightDays()
                 
             
             }
            
         }
            
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
               // let weekDays = ["M", "Ti", "O", "To", "F", "L", "S"]
                let weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                let combinedDays = daysToShow.enumerated().map { index, day -> (id: Int, day: Int) in
                    return (id: index, day: day)
                }
                
                
                
                LazyVGrid(columns: columns) {
                  
                    ForEach(weekDays, id: \.self) { day in
                        Text(day)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                            .background(Color.gray.opacity(0.2))  
                    }
                    
                    
                    ForEach(combinedDays, id: \.id) { dayInfo in
                        let dayDate = Calendar.current.date(bySetting: .day, value: dayInfo.day, of: firstDayOfMonth)!
                        let startOfDayDate = Calendar.current.startOfDay(for: dayDate)
                        let dateString = dateFormatter.string(from: startOfDayDate)
                        let isStreakDay = streakDaysSet.contains(dateString)
                        Text("\(dayInfo.day)")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                            .background(isStreakDay ? Color.green : Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                        
                    }
                    
                }
                VStack{
                    Text("CurrentStreak:\(currentStreak)")
                    Text("HighestStreak: \(highestStreak)")
                }
            }
            .onAppear {
            
                fetchStreakHistory()
                showRightDays()
                loadHabits()
                
            }
        }
    func loadHabits() {
        self.habits = []

        let db = Firestore.firestore()
        db.collection("habits").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let habitId = document.documentID
                    var habitName = "Standard Namn"

                    if let habit = document.data()["habit"] as? String {
                        habitName = habit
                    }

                    let newHabit = Habit(id: habitId, habitName: habitName)
                    self.habits.append(newHabit)
                    print(habitId)
                }
            }
        }
    }
      

        func showRightDays() {
            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: firstDayOfMonth)
            let daysInPreviousMonth = calendar.range(of: .day, in: .month, for: calendar.date(byAdding: .month, value: -1, to: firstDayOfMonth)!)!.count
            let numDaysToAdd = max(0, weekday - 2)
            
            daysToShow = (daysInPreviousMonth - numDaysToAdd + 1...daysInPreviousMonth).map { $0 } + daysInMonth
            
           
            print("Weekday: \(weekday)")
            print("Days in Previous Month: \(daysInPreviousMonth)")
            print("Number of Days to Add: \(numDaysToAdd)")
            print("Days to Show: \(daysToShow)")
        }
        
        
        func fetchStreakHistory() {
            let db = Firestore.firestore()
            db.collection("habits").document(habitId).getDocument { (document, error) in
                if let streakHistory = document?.data()?["streakHistory"] as? [Timestamp] {
                    print("Streak History: \(streakHistory)")
                   
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                    let dateStrings = streakHistory.map { timestamp -> String in
                        let date = timestamp.dateValue()
                        let dateString = dateFormatter.string(from: date)
                        print("Formatted Date String: \(dateString)")
                        
                        return dateString
                    }
                    print("Date Strings: \(dateStrings)")
                    self.streakDaysSet = Set(dateStrings)
                    print("Streak Days Set: \(self.streakDaysSet)")
                    
                    
                } 
                if let currentStreak = document?.data()?["currentStreak"] as? Int {
                    self.currentStreak = currentStreak
                  }
                  if let highestStreak = document?.data()?["highestStreak"] as? Int {
                      self.highestStreak = highestStreak
                  }
                if let habit = document?.data()?["habit"] as? String {
                    self.habitName = habit
                }else {
                    print("No streakHistory data found or wrong data type.")
                }
             
            }
        }
        
        
        
        
    }

