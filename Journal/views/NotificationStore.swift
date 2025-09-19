import Foundation
import CoreData
import UserNotifications

final class NotificationStore {
    static let shared = NotificationStore()
    private let container = PersistenceController.shared.container
    
    private init() {}
    
    func saveNotification(from content: UNNotificationContent) {
        let ctx = container.newBackgroundContext()
        ctx.perform {
            let n = NotificationEntity(context: ctx)
            n.id = UUID()
            n.title = content.title
            n.body = content.body
            n.receivedAt = Date()
            
           
            if JSONSerialization.isValidJSONObject(content.userInfo),
               let data = try? JSONSerialization.data(withJSONObject: content.userInfo, options: []) {
                n.userInfo = data
            }
            
            do {
                try ctx.save()
            } catch {
                print("Error saving notification:", error)
            }
        }
    }
}
