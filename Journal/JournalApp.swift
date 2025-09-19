//
//  JournalApp.swift
//  Journal
//
//  Created by proushoth koushal on 8/19/25.
//

import SwiftUI
import UserNotifications

@main
struct JournalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
           
           
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .onAppear {
                       
                        NotificationManager.shared.requestPermission()
                        
                        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
                    }
         
        }
    }
}


class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    
    private override init() {}
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
 
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      
        print("Notification tapped: \(response.notification.request.identifier)")
        completionHandler()
    }
}
