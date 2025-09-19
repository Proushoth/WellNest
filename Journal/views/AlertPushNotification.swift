import SwiftUI
import UIKit
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func scheduleHabitReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Habits Reminder"
        content.body = "Time to check your daily habits!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 16 // 24-hour format
        dateComponents.minute = 30
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "habitReminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    // For testing purposes - triggers notification after 5 seconds
    func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermission()
        return true
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
                DispatchQueue.main.async {
                    NotificationManager.shared.scheduleHabitReminder()
                }
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}

struct AlertPushNotification: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showTestButton = true
    
    var body: some View {
        VStack {
            Text("Notification Settings")
                .font(.title)
                .padding()
            
            if showTestButton {
                Button("Test Notification") {
                    NotificationManager.shared.scheduleTestNotification()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Text("Daily reminder set for 4:30 PM")
                .padding()
        }
    }
}

#Preview {
    AlertPushNotification()
}
