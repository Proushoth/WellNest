import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
   
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
   
    func scheduleHabitNotification(for habitName: String, habitId: UUID) {
        let content = UNMutableNotificationContent()
        content.title = "New Habit Created! 🎉"
        content.body = "You've successfully created '\(habitName)'. Let's build this habit together!"
        content.sound = .default
        content.badge = 1
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
       
        let request = UNNotificationRequest(
            identifier: "habit_created_\(habitId.uuidString)",
            content: content,
            trigger: trigger
        )
        
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for habit: \(habitName)")
            }
        }
    }
    
    
    func scheduleDailyReminder(for habitName: String, habitId: UUID, at time: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = "Time for your habit! ⏰"
        content.body = "Don't forget to complete '\(habitName)' today!"
        content.sound = .default
        content.badge = 1
        
      
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
        
    
        let request = UNNotificationRequest(
            identifier: "daily_reminder_\(habitId.uuidString)",
            content: content,
            trigger: trigger
        )
        
     
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily reminder: \(error.localizedDescription)")
            } else {
                print("Daily reminder scheduled for habit: \(habitName)")
            }
        }
    }
    

    func removeNotifications(for habitId: UUID) {
        let identifiers = [
            "habit_created_\(habitId.uuidString)",
            "daily_reminder_\(habitId.uuidString)"
        ]
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
    }
    

    func checkPermissionStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
}
