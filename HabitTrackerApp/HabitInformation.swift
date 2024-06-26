//
//  HabitInformation.swift
//  HabitTrackerApp
//
//  Created by Alvin Johansson on 2024-04-22.
//

import Foundation
enum Weekday: String,CaseIterable, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday , sunday
}
struct HabitInformation: Identifiable,Equatable {
    
    var id: String
    var note: String
    var userId: String
    var currentStreak: Int
    var highestStreak: Int
    var alertTime : Date
    var streakHistory: [Date]
    var category: Int
    var daysActive: [Weekday]
    var streakDone : Bool

    
    init(id: String, note: String,userId: String,currentStreak: Int,highestStreak: Int,alertTime : Date,streakHistory: [Date],category : Int, daysActive: [Weekday],streakDone: Bool) {
        self.id = id
        self.note = note
        self.userId = userId
        self.currentStreak = currentStreak
        self.highestStreak = highestStreak
        self.alertTime = alertTime
        self.streakHistory = streakHistory
        self.category = category
        self.daysActive = daysActive
        self.streakDone = streakDone
    }
    
}
