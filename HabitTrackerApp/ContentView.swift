//
//  ContentView.swift
//  HabitTrackerApp
//
//  Created by Alvin Johansson on 2024-04-22.
//

import SwiftUI
import Firebase
import UIKit
struct ContentView: View {
        @State var signedIn = false
    
   
        var body: some View {
            if !signedIn{
                SignInView(signedIn: $signedIn)
    
            }else{
                HabitTrackerView()
            }
    
    
        }
}
struct rowView: View {
    
    let entry: HabitInformation
    
    var body: some View {
        HStack {
            Text(entry.note)
                       

        }
    }
}


struct SignInView : View {
    @Binding var signedIn: Bool
    var auth = Auth.auth()
    @State var password: String = ""
    @State var email: String = ""

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                    Text("Email:")
                    TextEditor(text: $email)
                        .frame(height: 35)
                    Text("Password:")
                    TextEditor(text: $password)
                        .frame(height: 35)
                }
            .frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 20)
            Button(action: {
                auth.signIn(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("Error signing in: \(error)")
                    } else {
                        signedIn = true
                    }
                }
            }, label: {
                Text("Sign in")
            })
        }
        .onAppear {
            if Auth.auth().currentUser != nil {
                signedIn = true
            }
        }
    }
}
extension Int {
    func toWeekday() -> Weekday? {
        switch self {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return nil
        }
    }
}

struct HabitTrackerView : View{
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var habit: HabitViewModel
    
    
    var body: some View {
        let currentDate = Date()
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let daysInMonth = Array(1...range.count)
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        // components.day = 1
        let firstDayOfMonth = calendar.date(from: components)!
        
        let currentDay = Calendar.current.component(.weekday, from: Date())
        let currentWeekday = currentDay.toWeekday()
        Text(currentWeekday?.rawValue.capitalized ?? "Unkown Day")
        TabView {
            NavigationStack {
                List {
                    ForEach(habit.noteEntries.filter { entry in
                        entry.daysActive.contains(currentWeekday!)
                    }) { entry in
                        NavigationLink(destination: HabitEntryView(habitEntry: entry, alertTime: Date(), streakHistory: [Date()], daysActive: [])) {
                            categoryView(for: entry)
                        }
                    }
                }
                .navigationTitle("Habits")
                .navigationBarItems(trailing: NavigationLink(destination: HabitEntryView(alertTime: Date(), streakHistory: [Date()], daysActive: [])) {
                    Image(systemName: "plus.circle")
                })
            }
            .tabItem {
                Label("Habits", systemImage: "list.bullet")
            }

            NavigationStack {
                CalendarView(daysInMonth: daysInMonth, firstDayOfMonth: firstDayOfMonth, habitId: "ppen7o0pDwowGa88P8Q8")
                    .navigationTitle("Calendar")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
//                            Button("Tillbaka") {
//                                // Använd .dismiss() för att gå tillbaka
//                                presentationMode.wrappedValue.dismiss()
//                                
//                            }
                        }
                    }
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }

        }
    }

    
    
    
    
    
    func categoryView(for habitInfo: HabitInformation) -> some View {
        let db = Firestore.firestore()
        let customBlue = Color(red: 0x3D / 255.0, green: 0x84 / 255.0, blue: 0xB7 / 255.0)
        let customGreen = Color(red: 0x29 / 255.0, green: 0x7E / 255.0, blue: 0x7E / 255.0)
        switch habitInfo.category {
        case 1:
            return AnyView(VStack {
                HStack {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .foregroundColor(Color.white)
                    Spacer()
                    Text(habitInfo.note)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: habitInfo.streakDone ? "checkmark.circle.fill" : "circle.fill")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        streak()
                    })
                }
                .padding()
                .background(customGreen)
                .foregroundColor(Color.white)
                .cornerRadius(10)
            })
        case 2:
            return AnyView(VStack {
                HStack {
                    Image(systemName: "fork.knife")
                        .foregroundColor(Color.white)
                    Spacer()
                    Text(habitInfo.note)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: habitInfo.streakDone ? "checkmark.circle.fill" : "circle.fill")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        streak()
                    })
                }
                
                .padding()
                .background(customBlue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
            })
        case 3:
            return AnyView(VStack {
                HStack {
                    Image(systemName: "tree.fill")
                        .foregroundColor(Color.white)
                    Spacer()
                    Text(habitInfo.note)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: habitInfo.streakDone ? "checkmark.circle.fill" : "circle.fill")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        streak()
                    })
                }
                
                .padding()
                .background((Color(UIColor.fromHex("7BB384"))))
                .foregroundColor(Color.white)
                .cornerRadius(10)
            })
        case 4:
            return AnyView(VStack {
                HStack {
                    Image(systemName: "bag.fill")
                        .foregroundColor(Color.white)
                    Spacer()
                    Text(habitInfo.note)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: habitInfo.streakDone ? "checkmark.circle.fill" : "circle.fill")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        streak()
                    })
                }
                
                .padding()
                .background(Color(UIColor.fromHex("FA8F8F")))
                .foregroundColor(Color.white)
                .cornerRadius(10)
            })
        case 5:
            return AnyView(VStack {
                HStack {
                    Image(systemName: "graduationcap.fill")
                        .foregroundColor(Color.white)
                    Spacer()
                    Text(habitInfo.note)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: habitInfo.streakDone ? "checkmark.circle.fill" : "circle.fill")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        streak()
                    })
                }
                
                .padding()
                .background(Color(UIColor.fromHex("F2A9DD")))
                .foregroundColor(Color.white)
                .cornerRadius(10)
            })
        case 6:
            return AnyView(VStack {
                HStack {
                    Image(systemName: "tv.fill")
                        .foregroundColor(Color.white)
                    Spacer()
                    Text(habitInfo.note)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: habitInfo.streakDone ? "checkmark.circle.fill" : "circle.fill")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        streak()
                    })
                }
                
                .padding()
                .background(Color(UIColor.fromHex("A0D7FF")))
                .foregroundColor(Color.white)
                .cornerRadius(10)
            })
        case 7:
            return AnyView(VStack {
                HStack {
                    Image(systemName: "photo.artframe")
                        .foregroundColor(Color.white)
                    Spacer()
                    Text(habitInfo.note)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: habitInfo.streakDone ? "checkmark.circle.fill" : "circle.fill")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        streak()
                    })
                }
                
                .padding()
                .background(Color(UIColor.fromHex("FFF1A6")))
                .foregroundColor(Color.white)
                .cornerRadius(10)
            })
        case 8:
            return AnyView(VStack {
                HStack {
                    Image(systemName: "message.fill")
                        .foregroundColor(Color.white)
                    Spacer()
                    Text(habitInfo.note)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: habitInfo.streakDone ? "checkmark.circle.fill" : "circle.fill")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        streak()
                    })
                }
                
                .padding()
                .background(Color(UIColor.fromHex("9493CB")))
                .foregroundColor(Color.white)
                .cornerRadius(10)
            })
        case 9:
            return AnyView(VStack {
                HStack {
                    Image(systemName: "cross.fill")
                        .foregroundColor(Color.white)
                    Spacer()
                    Text(habitInfo.note)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: habitInfo.streakDone ? "checkmark.circle.fill" : "circle.fill")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        streak()
                    })
                }
                
                .padding()
                .background(Color(UIColor.fromHex("BD7EBE")))
                .foregroundColor(Color.white)
                .cornerRadius(10)
            })
        case 10:
            return AnyView(VStack {
                HStack {
                    Image(systemName: "guitars.fill")
                        .foregroundColor(Color.white)
                    Spacer()
                    Text(habitInfo.note)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: habitInfo.streakDone ? "checkmark.circle.fill" : "circle.fill")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        streak()
                    })
                }
                
                .padding()
                .background(Color(UIColor.fromHex("7E8AF3")))
                .foregroundColor(Color.white)
                .cornerRadius(10)
            })
        default:
            return AnyView(VStack {
                Text("Andra kategorier här")
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            })
        }
        func streak() {
            let newStreakDone = !habitInfo.streakDone
            let documentReference = db.collection("habits").document(habitInfo.id)

         
            documentReference.updateData(["streakDone" : newStreakDone])

            let today = Calendar.current.startOfDay(for: Date())

            if newStreakDone {
               
                documentReference.updateData([
                    "streakHistory": FieldValue.arrayUnion([today])
                ])

           
                let newStreak = habitInfo.currentStreak + 1
                documentReference.updateData(["currentStreak" : newStreak])

            } else {
               
                documentReference.updateData([
                    "streakHistory": FieldValue.arrayRemove([today])
                ])

               
                let newStreak = max(0, habitInfo.currentStreak - 1)
                documentReference.updateData(["currentStreak" : newStreak])
            }
        }


    }
}


    #Preview {
        ContentView()
  
    
    }
    
