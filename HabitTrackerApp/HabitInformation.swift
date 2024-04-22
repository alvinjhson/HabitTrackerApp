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
    
    init(id: String, note: String,userId: String) {
        self.id = id
        self.note = note
        self.userId = userId
    }
    
}
