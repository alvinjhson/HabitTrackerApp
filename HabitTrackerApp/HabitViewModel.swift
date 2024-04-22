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
        var auth = Auth.auth().currentUser?.uid
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
                    let userId = Auth.auth().currentUser?.uid
                    
                    
                    
                    self.noteEntries.append(HabitInformation(id: id, note: note,userId: userId!))
                }
            }
        }
    
    

   
}
