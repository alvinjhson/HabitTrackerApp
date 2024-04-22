//
//  HabitViewModel.swift
//  HabitTrackerApp
//
//  Created by Alvin Johansson on 2024-04-22.
//

import Foundation
import FirebaseFirestore
class HabitViewModel : ObservableObject {
    @Published var noteEntries = [HabitInformation]()
    
    init(){
        
        setupSnapshotListener()
      
    }

    func update(entry: HabitInformation, with note: String) {
        let db = Firestore.firestore()
        db.collection("habits").document(entry.id).updateData([
            "habit": note
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    func setupSnapshotListener() {
            let db = Firestore.firestore()
            db.collection("habits").addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error listening for document changes: \(error)")
                    return
                }

                self.noteEntries.removeAll()
                for document in querySnapshot!.documents {
                    let note = document.data()["habit"] as? String ?? ""
                    let id = document.documentID
                    self.noteEntries.append(HabitInformation(id: id, note: note))
                }
            }
        }
    
    

   
}
