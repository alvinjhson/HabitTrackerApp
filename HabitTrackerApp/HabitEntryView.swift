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
import UIKit
extension UIColor {
    static func fromHex(_ hex: String) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

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
    @State private var showingSheet = false
    @State var specificDay = false
    @State var streakDone = false
    @ObservedObject var notificationVM = NotificationViewModel()
    @State private var showingDatePicker = false
    
    
    
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            //Spacer()
            VStack{
                Text("What is your habit?")
                TextEditor(text: $note)
                    .frame(width: 300,height: 35)
                    .background(Color.black)
                                 .foregroundColor(.black)
                                 .clipShape(Capsule())
                                 .overlay(
                                       Capsule().stroke(Color.blue, lineWidth: 2)
                                   )
                                
            }
            VStack {
                        Button("Välj tid för påminnelse") {
                            showingDatePicker = true
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .sheet(isPresented: $showingDatePicker) {
                        VStack {
                            Text("Välj en tid för din påminnelse:")
                            DatePicker("Alert Time", selection: $notificationVM.alertTime, displayedComponents: .hourAndMinute)
                                .datePickerStyle(WheelDatePickerStyle())
                                .labelsHidden()
                            
                            Button("Spara") {
                                notificationVM.scheduleNotification()
                                showingDatePicker = false
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding()
                    }
            Spacer()
            Text("Select a day of habit")
                .bold()
            HStack{
                
                Circle()
                    .frame(width: 25,height: 25)
                    .foregroundColor(showingSheet ==  true||specificDay ==  true ? Color.blue :customGrey)
                    .onTapGesture {
                        showingSheet = true
                        specificDay = true
                    }
                Text("Specific days")
                    .padding(.trailing,207)
                  
                    .sheet(isPresented: $showingSheet) {
                               ChooseDaySheet(daysActive: $daysActive)
                           }
            }
            HStack{
                Circle()
                    .frame(width: 25,height: 25)
                   
                    .foregroundColor(daysActive == [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday] && specificDay ==  !true   ? Color.blue : customGrey)  .foregroundColor(Color.white)
                    .cornerRadius(10) // Runda hörnen
                    .onTapGesture {
                        daysActive = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
                        specificDay = false
                    }
                Text("Every day")
                    .padding(.trailing,235)
            }
            HStack{
                Circle()
                    .frame(width: 25,height: 25)
                    .foregroundColor(daysActive == [.saturday, .sunday] && specificDay ==  !true ? Color.blue :customGrey)
                   
                    .cornerRadius(10)
                 .foregroundColor(Color.white)
                
                    .onTapGesture {
                        daysActive = [.saturday, .sunday]
                        specificDay = false
                    }
                Text("Weekends")
                    .padding(.trailing,230)
    
            }
           
            Text("Select a category for your habit")
                .bold()
            HStack {
                // Card 1
                VStack {
                    HStack {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        Text("Fitness")
                        Spacer()
                    }
                    .padding()
                }
                .background(category == 1 ? Color.blue :customGreen)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .onTapGesture {
                    category = 1
                    
                }

                // Card 2
                VStack {
                    HStack {
                        Image(systemName: "fork.knife")
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("Nutrition")
                        Spacer()
                    }
                    .padding()
                }
                .background(category == 2 ? Color.blue : customBlue)  .foregroundColor(Color.white)
                .cornerRadius(10)
                .onTapGesture {
                    category = 2
                }
                
            }
            HStack {
                // Card 3
                VStack {
                    HStack {
                        Image(systemName: "tree.fill")
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("Outdoor")
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding()
                }
                .background(category == 3 ? Color.blue :Color(UIColor.fromHex("7BB384")))
                .cornerRadius(10)
                .onTapGesture {
                    category = 3
                }

                // Card 4
                VStack {
                    HStack {
                        Image(systemName: "bag.fill")
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("Work")
                            .foregroundColor(Color.white)
                      
                        Spacer()
                    }
                    .padding()
                }
                .background(category == 4 ? Color.blue : Color(UIColor.fromHex("FA8F8F")))
                .cornerRadius(10)
                .onTapGesture {
                    category = 4
                }
                
                
            }
            HStack {
                // Card 5
                VStack {
                    HStack {
                        Image(systemName: "graduationcap.fill")
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("Study")
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding()
                }
                .background(category == 5 ? Color.blue :Color(UIColor.fromHex("F2A9DD")))
                .cornerRadius(10)
                .onTapGesture {
                    category = 5
                }

                // Card 6
                VStack {
                    HStack {
                        Image(systemName: "tv.fill")
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("Entrertainment")
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding()
                }
                .background(category == 6 ? Color.blue : Color(UIColor.fromHex("A0D7FF")))
                .cornerRadius(10)
                .onTapGesture {
                    category = 6
                }
                
                
            }
            HStack {
                // Card 7
                VStack {
                    HStack {
                        Image(systemName: "photo.artframe")
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("Art")
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding()
                }
                .background(category == 7 ? Color.blue : Color(UIColor.fromHex("FFF1A6")))
                .cornerRadius(10)
                .onTapGesture {
                    category = 7
                }

                // Card 8
                VStack {
                    HStack {
                        Image(systemName: "message.fill")
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("Social")
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding()
                }
                .background(category == 8 ? Color.blue : Color(UIColor.fromHex("9493CB")))
                .cornerRadius(10)
                .onTapGesture {
                    category = 8
                }
                
                
            }
            HStack {
                // Card 9
                VStack {
                    HStack {
                        Image(systemName: "cross.fill")
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("Health")
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding()
                }
                .background(category == 9 ? Color.blue : Color(UIColor.fromHex("BD7EBE")))
                .cornerRadius(10)
                .onTapGesture {
                    category = 9
                }

                // Card 10
                VStack {
                    HStack {
                        Image(systemName: "guitars.fill")
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("Hobbies")
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding()
                }
                .background(category == 10 ? Color.blue : Color(UIColor.fromHex("7E8AF3")))
                .cornerRadius(10)
                .onTapGesture {
                    category = 10
                }
                
                
            }
            
            
            
            
            
            
            
           
        }
        
        .onAppear(perform: setContent)
        .navigationBarItems(trailing: Button("save"){
            saveEntry()
            presentationMode.wrappedValue.dismiss()
            
        })
        
    }

    struct ChooseDaySheet: View {
        @Binding var daysActive: [Weekday]

        var body: some View {
            VStack {
                ForEach(Weekday.allCases, id: \.self) { day in
                    Toggle(isOn: Binding(
                        get: { daysActive.contains(day) },
                        set: { newValue in
                            if newValue {
                                if !daysActive.contains(day) {
                                    daysActive.append(day)
                                }
                            } else {
                                daysActive.removeAll { $0 == day }
                            }
                        }
                    )) {
                        Text(day.rawValue.capitalized)
                    }
                }
            }
        }
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
            "daysActive": daysActiveStrings,
            "streakDone": streakDone
           // "alertTime": alertTime ?? "No alertTime",
            //"streakHistory":streakHistory ?? "No streakHistory"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else if let ref = ref {
                print("Document added with ID: \(ref.documentID)")
                let newEntry = HabitInformation(id: ref.documentID, note: note,userId:userId!,currentStreak: 0,highestStreak: 0,alertTime: Date(),streakHistory: [Date()],category: category,daysActive: daysActive,streakDone: streakDone)
            }

        }
    }
}
//#Preview {
//    HabitEntryView( daysActive: [])
// 
//}
