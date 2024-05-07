//
//  NotificationViewModel.swift
//  HabitTrackerApp
//
//  Created by Alvin Johansson on 2024-05-07.
//

import Foundation
import UserNotifications
class NotificationViewModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var alertTime: Date = Date()
    //UNUserNotificationCenter.current().delegate = self
    override init() {
         super.init()
         UNUserNotificationCenter.current().delegate = self
         requestPermissions()
     }

    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    // Uppdatera appens UI eller tillstånd om nödvändigt
                }
            } else if let error = error {
                print("Error: (error.localizedDescription)")
            }
        }
    }

    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Time to do your daily habits!"
        content.sound = .default

        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: alertTime)

        print("Schemalägger notifikation för \(dateComponents.hour!):\(dateComponents.minute!)")  // Visar vald tid

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Kunde inte schemalägga notifikation: \(error.localizedDescription)")
            } else {
                print("Notifikation schemalagd framgångsrikt!")
            }
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
             completionHandler([.banner, .sound]) // Ändra detta beroende på vilka typer av alert du vill visa
         }
}


