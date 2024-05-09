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
        timerStreak()
        
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
    func timerStreak() {
        let calendar = Calendar.current
        var nextMidnight = calendar.nextDate(after: Date(), matching: DateComponents(hour: 23, minute: 59), matchingPolicy: .nextTime)!
        let timer = Timer(fireAt: nextMidnight, interval: 0, target: self, selector: #selector(midnightReset), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
    }

    @objc func midnightReset() {
      
        checkStreak()
        resetStreakDone()
    }



   func resetStreakDone() {
        let db = Firestore.firestore()
        db.collection("habits").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.updateData(["streakDone": false]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated!")
                        }
                    }
                }
            }
        }
        print("Reset at midnight")

    }
    
    func checkStreak() {
        let db = Firestore.firestore()
        let calendar = Calendar.current
        let todayDate = Date()
        let weekdayNumber = calendar.component(.weekday, from: todayDate) - 1
        let weekday = Weekday.allCases[weekdayNumber % 7]
        db.collection("habits")
           .whereField("daysActive", arrayContains: weekday.rawValue)
           .addSnapshotListener { querySnapshot, error in
               if let error = error {
                   print("Error getting documents: \(error)")
               } else {
                   for document in querySnapshot!.documents {
                       print("\(document.documentID) => \(document.data())")
                       let calendar = Calendar.current
                       let today = calendar.startOfDay(for: Date())

                    
                       let documentData = document.data()
                       if let streakHistory = documentData["streakHistory"] as? [Timestamp] {
                           let streakDates = streakHistory.map { calendar.startOfDay(for: $0.dateValue()) }
                           if streakDates.contains(today) {
                               print("todays date is in streakhistory.")
                           } else {
                               print("today date not in streakhistory!")
                                  
                                   let currentStreak = documentData["currentStreak"] as? Int ?? 0
                                   let highestStreak = documentData["highestStreak"] as? Int ?? 0
                               let documentRef = db.collection("habits").document(document.documentID)
                               documentRef.updateData([
                                   "currentStreak": 0
                               ]) { err in
                                   if let err = err {
                                       print("Error \(err)")
                                   } else {
                                       print("current streak is 0")
                                   }
                               }
                                   
                                   if currentStreak > highestStreak {
                                       print("new highest streak \(currentStreak)")
                                       
                                       let documentRef = db.collection("habits").document(document.documentID)
                                       documentRef.updateData([
                                           "highestStreak": currentStreak
                                       ]) { err in
                                           if let err = err {
                                               print("error \(err)")
                                           } else {
                                               print("hiegest streak is \(currentStreak)")
                                           }
                                       }
                                   } else {
                                       print("no new streak")
                                   }
                        
                           }
                       }
                   }
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
                let streakDone = document.data()["streakDone"] as? Bool ?? false

                self.noteEntries.append(HabitInformation(id: id, note: note, userId: userId,currentStreak: currentStreak,highestStreak: highestStreak,alertTime: alertTime,streakHistory: streakHistory,category: category,daysActive: daysActive,streakDone: streakDone))
            }
        }
    }
    
    

   
}
