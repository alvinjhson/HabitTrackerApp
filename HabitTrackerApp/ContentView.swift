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
    @State var password : String = ""
    @State var email : String = ""
    
    var body: some View {
        HStack{
            Text("Email:")
            TextEditor(text: $email)
                .frame(height: 35)
            Text("Password:")
            TextEditor(text: $password)
                .frame(height: 35)
        }
        Button(action: {
            auth.signIn(withEmail: email, password: password)  { result, error in
                                if let error = error {
                                    print("error signing in ")
                                }else{
                                    signedIn = true
                
                                }
                
                
                            }
                
            
//            auth.signInAnonymously { result, error in
//                if let error = error {
//                    print("error signing in ")
//                }else{
//                    signedIn = true
//                    
//                }
//                
//                
//            }
           
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
