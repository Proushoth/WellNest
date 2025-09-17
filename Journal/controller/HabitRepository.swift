//import Foundation
//import CoreData
//
//class HabitRepository {
//    static var shared = HabitRepository()
//    
//    private init() {}
//    
//    // Get the managed object context from your app's persistence controller
//    private var context: NSManagedObjectContext {
//        // Replace this with your actual persistence controller
//        // For example: PersistenceController.shared.container.viewContext
//        return PersistenceController.shared.container.viewContext
//    }
//    
//    // MARK: - Create Habit
//    static func createHabit(name: String) {
//        let context = shared.context
//        
//        let newHabit = Habit(context: context)
//        newHabit.id = UUID()
//        newHabit.name = name
//        newHabit.createdAt = Date()
//        newHabit.streak = 0
//        newHabit.isActive = true
//        newHabit.lastCompleted = nil
//        
//        do {
//            try context.save()
//            print("Habit created successfully: \(name)")
//        } catch {
//            print("Failed to create habit: \(error.localizedDescription)")
//        }
//    }
//    
//    // MARK: - Mark Habit as Done
//    static func markHabitDone(_ habit: Habit) {
//        let context = shared.context
//        let today = Date()
//        
//        // Check if already completed today
//        if let lastCompleted = habit.lastCompleted,
//           Calendar.current.isDateInToday(lastCompleted) {
//            return // Already completed today
//        }
//        
//        // Create a new habit entry
//        let entry = HabitEntry(context: context)
//        entry.id = UUID()
//        entry.completedAt = today
//        entry.habit = habit
//        
//        // Update habit properties
//        habit.lastCompleted = today
//        
//        // Calculate new streak
//        if let lastCompleted = habit.lastCompleted {
//            let calendar = Calendar.current
//            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
//            
//            if calendar.isDate(lastCompleted, inSameDayAs: yesterday) ||
//               calendar.isDateInToday(lastCompleted) {
//                habit.streak += 1
//            } else {
//                habit.streak = 1 // Reset streak if not consecutive
//            }
//        } else {
//            habit.streak = 1
//        }
//        
//        do {
//            try context.save()
//            print("Habit marked as done: \(habit.name ?? "")")
//        } catch {
//            print("Failed to mark habit as done: \(error.localizedDescription)")
//        }
//    }
//    
//    // MARK: - Reset Habit for Today
//    static func resetHabitForToday(_ habit: Habit) {
//        let context = shared.context
//        let calendar = Calendar.current
//        let today = Date()
//        let startOfDay = calendar.startOfDay(for: today)
//        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
//        
//        // Find today's entries
//        let fetchRequest: NSFetchRequest<HabitEntry> = HabitEntry.fetchRequest()
//        fetchRequest.predicate = NSPredicate(
//            format: "habit == %@ AND completedAt >= %@ AND completedAt < %@",
//            habit, startOfDay as NSDate, endOfDay as NSDate
//        )
//        
//        do {
//            let todayEntries = try context.fetch(fetchRequest)
//            
//            // Delete today's entries
//            for entry in todayEntries {
//                context.delete(entry)
//            }
//            
//            // Update habit properties
//            habit.lastCompleted = nil
//            
//            // Recalculate streak
//            habit.streak = calculateStreak(for: habit, excluding: today)
//            
//            try context.save()
//            print("Habit reset for today: \(habit.name ?? "")")
//        } catch {
//            print("Failed to reset habit: \(error.localizedDescription)")
//        }
//    }
//    
//    // MARK: - Delete Habit
//    static func deleteHabit(_ habit: Habit) {
//        let context = shared.context
//        
//        // Soft delete - mark as inactive
//        habit.isActive = false
//        
//        do {
//            try context.save()
//            print("Habit deleted: \(habit.name ?? "")")
//        } catch {
//            print("Failed to delete habit: \(error.localizedDescription)")
//        }
//    }
//    
//    // MARK: - Calculate Streak
//    private static func calculateStreak(for habit: Habit, excluding excludeDate: Date? = nil) -> Int16 {
//        let context = shared.context
//        let fetchRequest: NSFetchRequest<HabitEntry> = HabitEntry.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "habit == %@", habit)
//        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \HabitEntry.completedAt, ascending: false)]
//        
//        do {
//            let entries = try context.fetch(fetchRequest)
//            var streak: Int16 = 0
//            var currentDate = Date()
//            let calendar = Calendar.current
//            
//            // If excluding a date, start from yesterday
//            if let excludeDate = excludeDate {
//                currentDate = calendar.date(byAdding: .day, value: -1, to: excludeDate) ?? currentDate
//            }
//            
//            // Check consecutive days
//            for entry in entries {
//                guard let completedAt = entry.completedAt else { continue }
//                
//                if calendar.isDate(completedAt, inSameDayAs: currentDate) {
//                    streak += 1
//                    currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
//                } else if completedAt < currentDate {
//                    break // Gap in streak
//                }
//            }
//            
//            return streak
//        } catch {
//            print("Failed to calculate streak: \(error.localizedDescription)")
//            return 0
//        }
//    }
//    
//    // MARK: - Get Completed Habits for Date
//    static func getCompletedHabits(for date: Date = Date()) -> [Habit] {
//        let context = shared.context
//        let calendar = Calendar.current
//        let startOfDay = calendar.startOfDay(for: date)
//        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
//        
//        let fetchRequest: NSFetchRequest<HabitEntry> = HabitEntry.fetchRequest()
//        fetchRequest.predicate = NSPredicate(
//            format: "completedAt >= %@ AND completedAt < %@",
//            startOfDay as NSDate, endOfDay as NSDate
//        )
//        fetchRequest.relationshipKeyPathsForPrefetching = ["habit"]
//        
//        do {
//            let entries = try context.fetch(fetchRequest)
//            let habits = entries.compactMap { $0.habit }
//            return Array(Set(habits)) // Remove duplicates
//        } catch {
//            print("Failed to fetch completed habits: \(error.localizedDescription)")
//            return []
//        }
//    }
//}
