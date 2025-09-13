//
//  GoalRepository.swift
//  Journal
//
//  Created by proushoth koushal on 9/13/25.
//

import CoreData

struct GoalRepository {
    
    static func addGoal(title: String, progress: Double, streak: String?, targetDate: String, color: String) -> Bool {
        let context = CoreDataManager.shared.context
        
        let newGoal = GoalEntity(context: context)
        newGoal.title = title
        newGoal.progress = progress
        newGoal.streak = streak
        newGoal.targetDate = targetDate
        newGoal.color = color
        
        do {
            try context.save()
            return true
        } catch {
            print("Core Data error: \(error.localizedDescription)")
            return false
        }
    }
    
    static func fetchGoals() -> [GoalEntity] {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<GoalEntity> = GoalEntity.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Core Data error: \(error.localizedDescription)")
            return []
        }
    }
    
    static func deleteGoal(goal: GoalEntity, context: NSManagedObjectContext) -> Bool {
        context.delete(goal)
        do {
            try context.save()
            return true
        } catch {
            print("Core Data error: \(error.localizedDescription)")
            return false
        }
    }
    
    static func updateGoal(goal: GoalEntity, title: String, progress: Double, streak: String?, targetDate: String, color: String) -> Bool {
        goal.title = title
        goal.progress = progress
        goal.streak = streak
        goal.targetDate = targetDate
        goal.color = color
        
        let context = CoreDataManager.shared.context
        do {
            try context.save()
            return true
        } catch {
            print("Core Data error: \(error.localizedDescription)")
            return false
        }
    }
}

