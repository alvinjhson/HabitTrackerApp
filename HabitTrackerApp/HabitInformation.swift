//
//  HabitInformation.swift
//  HabitTrackerApp
//
//  Created by Alvin Johansson on 2024-04-22.
//

import Foundation

struct HabitInformation: Identifiable,Equatable {
    
    var id: String
    var note: String
    var userId: String
    var currentStreak: Int
    var highestStreak: Int
    var alertTime : Date
    var streakHistory: [Date]
    
    init(id: String, note: String,userId: String,currentStreak: Int,highestStreak: Int,alertTime : Date,streakHistory: [Date]) {
        self.id = id
        self.note = note
        self.userId = userId
        self.currentStreak = currentStreak
        self.highestStreak = highestStreak
        self.alertTime = alertTime
        self.streakHistory = streakHistory
    }
    
}
