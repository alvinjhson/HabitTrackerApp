//
//  HabitEntryView.swift
//  HabitTrackerApp
//
//  Created by Alvin Johansson on 2024-04-22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import Firebase

struct HabitEntryView: View {
    
    var habitEntry : HabitInformation?
    @EnvironmentObject var habits : HabitViewModel
    
    let customBlue = Color(red: 0x3D / 255.0, green: 0x84 / 255.0, blue: 0xB7 / 255.0)
    let customGreen = Color(red: 0x29 / 255.0, green: 0x7E / 255.0, blue: 0x7E / 255.0)
    let customGrey = Color(red: 0xD9 / 255, green: 0xD9 / 255, blue: 0xD9 / 255)
    
    @State var note : String = ""
    @State var id : String = ""
    @State var currentStreak = 0
    @State var highestStreak = 0
    @State var alertTime : Date?
    @State var streakHistory : [Date]?
    @State var category = 0
    @State var daysActive: [Weekday]
    
    
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            
            VStack{
                Text("What is your habit?")
                TextEditor(text: $note)
                    .frame(width: 300,height: 35)
                    .background(Color.black) // Sätter bakgrundsfärgen till svart
                                 .foregroundColor(.black) // Sätter textfärgen till vit för bättre kontrast
                                 .clipShape(Capsule())
                                 .overlay(
                                       Capsule().stroke(Color.blue, lineWidth: 2) // Ändrar färg på capsule kanten till röd
                                   )
                                 
              
            }
            Spacer()
            Text("Select a day of habit")
                .bold()
            HStack{
                
                Circle()
                    .frame(width: 35,height: 35)
                    .foregroundColor(customGrey)
                   // .padding(.trailing,330)
                Text("Specific days")
                    .padding(.trailing,207)
                       
                
                
                    
            }
            HStack{
                Circle()
                    .frame(width: 35,height: 35)
                    .foregroundColor(customGrey)
                Text("Every day")
                    .padding(.trailing,235)
                    .background(daysActive.contains([.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]) ? Color.blue : customBlue)  .foregroundColor(Color.white)
                    .cornerRadius(10) // Runda hörnen
                    .onTapGesture {
                        daysActive = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
                    }
                    
            }
            HStack{
                Circle()
                    .frame(width: 35,height: 35)
                    .foregroundColor(customGrey)
                Text("Weekends")
                    .padding(.trailing,230)
                    .background(daysActive.contains([.saturday, .sunday]) ? Color.blue : customBlue)  .foregroundColor(Color.white)
                    .cornerRadius(10) // Runda hörnen
                    .onTapGesture {
                        daysActive = [.saturday, .sunday]
                    }
                
                    
            }
           
            Text("Select a category for your habit")
                .bold()
            HStack {
                // Första kortet
                VStack {
                    HStack {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .foregroundColor(Color.white)
                        // Symbolen till vänster
                        Spacer() // Skapar utrymme mellan symbolen och texten
                        Text("Fitness") // Texten i mitten
                        Spacer() // Skapar utrymme på höger sida så texten hamnar i mitten
                    }
                    .padding()
                }
                .background(category == 1 ? Color.blue :customGreen)
                .foregroundColor(Color.white)// Ändrar färg när kortet är valt
                .cornerRadius(10) // Runda hörnen
                .onTapGesture {
                    category = 1
                    
                }

                // Andra kortet
                VStack {
                    HStack {
                        Image(systemName: "fork.knife")
                            .foregroundColor(Color.white)// Symbolen till vänster
                        Spacer() // Skapar utrymme mellan symbolen och texten
                        Text("Nutrition") // Texten i mitten
                        Spacer() // Skapar utrymme på höger sida så texten hamnar i mitten
                    }
                    .padding()
                }
                .background(category == 2 ? Color.blue : customBlue)  .foregroundColor(Color.white)
                .cornerRadius(10) // Runda hörnen
                .onTapGesture {
                    category = 2
                }
                
            }
            HStack {
                // Första kortet
                VStack {
                    HStack {
                        Image(systemName: "star.fill") // Symbolen till vänster
                        Spacer() // Skapar utrymme mellan symbolen och texten
                        Text("Kort 1") // Texten i mitten
                        Spacer() // Skapar utrymme på höger sida så texten hamnar i mitten
                    }
                    .padding()
                }
                .background(category == 3 ? Color.blue : Color.gray) // Ändrar färg när kortet är valt
                .cornerRadius(10) // Runda hörnen
                .onTapGesture {
                    category = 3
                }

                // Andra kortet
                VStack {
                    HStack {
                        Image(systemName: "heart.fill") // Symbolen till vänster
                        Spacer() // Skapar utrymme mellan symbolen och texten
                        Text("Kort 2") // Texten i mitten
                        Spacer() // Skapar utrymme på höger sida så texten hamnar i mitten
                    }
                    .padding()
                }
                .background(category == 4 ? Color.blue : Color.gray) // Ändrar färg när kortet är valt
                .cornerRadius(10) // Runda hörnen
                .onTapGesture {
                    category = 4
                }
                
            }
            
            
            //.padding() // Lägg till padding runt he runt hela HStackill padding runt hela HStack
        }
        .onAppear(perform: setContent)
        .navigationBarItems(trailing: Button("save"){
            saveEntry()
            presentationMode.wrappedValue.dismiss()
            
        })
        
    }
    
    private func setContent() {
        if let habitEntry = habitEntry {
            note = habitEntry.note
            category = habitEntry.category
            daysActive = habitEntry.daysActive
            
        }
    }
    
    private func saveEntry() {
        if let habitEntry = habitEntry{
            
            habits.update(entry: habitEntry, with: note, with: category)
            
          
            //notes.update(entry: noteEntry , with: note)
            
        }else
        {
            addNewEntry()
        }
        
        
    }
    private func addNewEntry() {
        let daysActiveStrings = daysActive.map { $0.rawValue }
        print("addNewEntry called")
        var auth = Auth.auth()
        let userId = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        
        var ref: DocumentReference? = nil
        ref = db.collection("habits").addDocument(data: [
            "userId": userId,
            "habit": note,
            "currentStreak": currentStreak,
            "highestStreak": highestStreak,
            "category" : category,
            "daysActive": daysActiveStrings
           // "alertTime": alertTime ?? "No alertTime",
            //"streakHistory":streakHistory ?? "No streakHistory"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else if let ref = ref {
                print("Document added with ID: \(ref.documentID)")
                let newEntry = HabitInformation(id: ref.documentID, note: note,userId:userId!,currentStreak: 0,highestStreak: 0,alertTime: Date(),streakHistory: [Date()],category: category,daysActive: daysActive)
            }

        }
    }
}
#Preview {
    HabitEntryView( daysActive: [])
 
}
