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
struct HabitTrackerView : View{
    
    @EnvironmentObject var habit: HabitViewModel
    var body: some View {
        NavigationStack{
            VStack {
                List() {
                    ForEach(habit.noteEntries) { entry in
                        NavigationLink( destination:HabitEntryView(habitEntry: entry,alertTime: Date(),streakHistory: [Date()], daysActive: [])){
                            rowView(entry: entry)
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

#Preview {
 ContentView()
}
