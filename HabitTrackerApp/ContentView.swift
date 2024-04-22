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
//struct ContentView: View {
//    @State var signedIn = false
//    var body: some View {
//        if !signedIn{
//            SignInView(signedIn: $signedIn)
//            
//        }else{
//            HabitTrackerView()
//        }
//    
//        
//    }
//}
struct SignInView : View{
   @Binding var signedIn : Bool
    var auth = Auth.auth()
    
    var body: some View {
        Button(action: {
            auth.signInAnonymously { result, error in
                if let error = error {
                    print("error signing in ")
                }else{
                    signedIn = true
                    
                }
                
                
            }
           
        }, label: {
            Text("sign in")
        })
        
    }
}
struct HabitTrackerView : View{
    
    @EnvironmentObject var habit: HabitViewModel
    var body: some View {
        NavigationStack{
            VStack {
                List() {
                    ForEach(habit.noteEntries) { entry in
                        NavigationLink( destination:HabitEntryView(habitEntry: entry)){
                            rowView(entry: entry)
                        }
                        
                    }
                }
            }
            .navigationTitle("Habits")
            .navigationBarItems( trailing: NavigationLink(destination: HabitEntryView()) {
               Image(systemName: "plus.circle")
            })
        }
    }
}

#Preview {
    ContentView()
}
