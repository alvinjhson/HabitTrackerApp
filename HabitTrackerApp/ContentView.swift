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
//struct HabitEntry: Identifiable {
//    var id: String
//    var category: Int
//    // Andra egenskaper kan också finnas här
//}


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

struct HabitTrackerView : View{
    
    @EnvironmentObject var habit: HabitViewModel
    var body: some View {
        NavigationStack{
            VStack {
                List {
                    ForEach(habit.noteEntries) { entry in
                        NavigationLink(destination: HabitEntryView(habitEntry: entry, alertTime: Date(), streakHistory: [Date()], daysActive: [])) {
                            categoryView(for: entry)
                        }
                    }
                }
                
//                List() {
//                    ForEach(habit.noteEntries) { entry in
//                        NavigationLink( destination:HabitEntryView(habitEntry: entry,alertTime: Date(),streakHistory: [Date()], daysActive: [])){
//                            rowView(entry: entry)
//                        }
//                        
//                    }
//                }
            }
            .navigationTitle("Habits")
            .navigationBarItems( trailing: NavigationLink(destination: HabitEntryView(alertTime: Date(), streakHistory: [Date()], daysActive: [])) {
                Image(systemName: "plus.circle")
            })
        }
    }
}
    
    
func categoryView(for habitInfo: HabitInformation) -> some View {
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
    
