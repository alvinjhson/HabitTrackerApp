//
//  HabitViewModel.swift
//  HabitTrackerApp
//
//  Created by Alvin Johansson on 2024-04-22.
//

import Foundation
import FirebaseFirestore
import Firebase

class HabitViewModel : ObservableObject {
    @Published var noteEntries = [HabitInformation]()
    
    init(){
        
        setupSnapshotListener()
      
    }

    func update(entry: HabitInformation, with note: String,with category: Int) {
        let db = Firestore.firestore()
        db.collection("habits").document(entry.id).updateData([
            "habit": note,
            "category": category
            
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }

    func setupSnapshotListener() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("habits")
          .whereField("userId", isEqualTo: userId)
          .addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error listening for document changes: \(error)")
                return
            }

            self.noteEntries.removeAll()
            for document in querySnapshot!.documents {
                let note = document.data()["habit"] as? String ?? ""
                let id = document.documentID
                let userId = document.data()["userId"] as? String ?? ""
                let currentStreak = document.data()["currentStreak"] as? Int ?? 0
                let highestStreak = document.data()["highestStreak"] as? Int ?? 0
                let alertTime = document.data()["alertTime"] as? Date ?? Date()
                let streakHistory = document.data()["streakHistory"] as? [Date] ?? [Date()]
                let category = document.data()["category"] as? Int ?? 0
                let daysActiveStrings = document.data()["daysActive"] as? [String] ?? [String]()
                let daysActive = daysActiveStrings.compactMap { Weekday(rawValue: $0) }
                
                
                
                
                self.noteEntries.append(HabitInformation(id: id, note: note, userId: userId,currentStreak: currentStreak,highestStreak: highestStreak,alertTime: alertTime,streakHistory: streakHistory,category: category,daysActive: daysActive))
            }
        }
    }
    
    

   
}
