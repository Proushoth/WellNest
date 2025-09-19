import CoreData

struct UserRepository {

    static func signUp(email: String, password: String) -> Bool {
        let context = CoreDataManager.shared.context
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let existingUsers = try context.fetch(fetchRequest)
            if !existingUsers.isEmpty {
                print("User already exists")
                return false
            }
            
            let newUser = User(context: context)
            newUser.email = email
            newUser.password = password
            
            try context.save()
            return true
        } catch {
            print("Core Data error: \(error.localizedDescription)")
            return false
        }
    }
    
    static func login(email: String, password: String) -> Bool {
        let context = CoreDataManager.shared.context
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        do {
            let users = try context.fetch(fetchRequest)
            return !users.isEmpty
        } catch {
            print("Core Data error: \(error.localizedDescription)")
            return false
        }
    }
    
    static func resetPassword(email: String, newPassword: String) -> Bool {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let users = try context.fetch(fetchRequest)
            guard let user = users.first else {
                print("User not found")
                return false
            }
            
            user.password = newPassword
            try context.save()
            return true
        } catch {
            print("Core Data error: \(error.localizedDescription)")
            return false
        }
    }
}
