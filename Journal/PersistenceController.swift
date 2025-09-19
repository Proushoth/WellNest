import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "JournalModel") 
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }


    static var preview: PersistenceController = {
        
        
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

          
               for i in 1...5 {
                   let habit = Habit(context: viewContext)
                   habit.id = UUID()
                   habit.name = "Preview Habit \(i)"
                   habit.isCompleted = (i % 2 == 0)
                   habit.streak = Int32(i * 2)
                   habit.dateCreated = Date()
                   habit.lastCompletedDate = habit.isCompleted ? Date() : nil
               }

               do {
                   try viewContext.save()
               } catch {
                   let nsError = error as NSError
                   fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
               }
        
        
        return controller
    }()
}
