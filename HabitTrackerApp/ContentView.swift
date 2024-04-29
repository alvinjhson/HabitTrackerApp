//
//  ContentView.swift
//  HabitTrackerApp
//
//  Created by Alvin Johansson on 2024-04-22.
//

import SwiftUI
import Firebase
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
    
    
    @EnvironmentObject var habit: HabitViewModel
    
    
    var body: some View {
        
        let currentDay = Calendar.current.component(.weekday, from: Date())
           let currentWeekday = currentDay.toWeekday()
        Text(currentWeekday?.rawValue.capitalized ?? "Unkown Day")
        
        NavigationStack{
            VStack {
                List {
                    ForEach(habit.noteEntries.filter { entry in
                        entry.daysActive.contains(currentWeekday!)
                    }) { entry in
                        NavigationLink(destination: HabitEntryView(habitEntry: entry, alertTime: Date(), streakHistory: [Date()], daysActive: [])) {
                            categoryView(for: entry)
                        }
                    }

                }
                

            }
            .navigationTitle("Habits")
            .navigationBarItems( trailing: NavigationLink(destination: HabitEntryView(alertTime: Date(), streakHistory: [Date()], daysActive: [])) {
                Image(systemName: "plus.circle")
            })
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
                    // Toggle streakDone status
                    let newStreakDone = !habitInfo.streakDone
                    db.collection("habits").document(habitInfo.id).updateData(["streakDone" : newStreakDone])
                    
                    // Update currentStreak based on the new streakDone status
                    if newStreakDone {
                  
                        let today = Calendar.current.startOfDay(for: Date())
                       
                        db.collection("habits").document(habitInfo.id).updateData(["streakHistory" :today])
                        let newStreak = habitInfo.currentStreak + 1
                        db.collection("habits").document(habitInfo.id).updateData(["currentStreak" : newStreak])
                    } else {
                        let today = Calendar.current.startOfDay(for: Date())
                        let updatedStreakHistory = habitInfo.streakHistory.filter { date in
                            return Calendar.current.startOfDay(for: date) != today
                            
                        }
                        db.collection("habits").document(habitInfo.id).updateData(["streakHistory" : updatedStreakHistory])
                       
                        let newStreak = max(0, habitInfo.currentStreak - 1)
                        
                        db.collection("habits").document(habitInfo.id).updateData(["currentStreak" : newStreak])
                    }
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
                    // Toggle streakDone status
                    let newStreakDone = !habitInfo.streakDone
                    db.collection("habits").document(habitInfo.id).updateData(["streakDone" : newStreakDone])
                    
                    // Update currentStreak based on the new streakDone status
                    if newStreakDone {
                  
                        let today = Calendar.current.startOfDay(for: Date())
                       
                        db.collection("habits").document(habitInfo.id).updateData(["streakHistory" :today])
                        let newStreak = habitInfo.currentStreak + 1
                        db.collection("habits").document(habitInfo.id).updateData(["currentStreak" : newStreak])
                    } else {
                        let today = Calendar.current.startOfDay(for: Date())
                        let updatedStreakHistory = habitInfo.streakHistory.filter { date in
                            return Calendar.current.startOfDay(for: date) != today
                            
                        }
                        db.collection("habits").document(habitInfo.id).updateData(["streakHistory" : updatedStreakHistory])
                       
                        let newStreak = max(0, habitInfo.currentStreak - 1)
                        
                        db.collection("habits").document(habitInfo.id).updateData(["currentStreak" : newStreak])
                    }
                })
            }
            
            .padding()
            .background(customBlue)
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
}

    #Preview {
        ContentView()
  
    
    }
    
