//
//  JournalTests.swift
//  JournalTests
//
//  Created by proushoth koushal on 8/19/25.
//

import XCTest
import CoreData
@testable import Journal

class JournalTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        context = PersistenceController(inMemory: true).container.viewContext
    }
    
    override func tearDown() {
        context = nil
        super.tearDown()
    }
    

    func testUserLogin() {
        let email = "test@example.com"
        let password = "password123"
        
        XCTAssertTrue(UserRepository.login(email: email, password: password))
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "isLoggedIn"))
    }
    
    func testUserLogout() {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set("testUser", forKey: "username")
        
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "username")
        
        XCTAssertNil(UserDefaults.standard.string(forKey: "username"))
        XCTAssertFalse(UserDefaults.standard.bool(forKey: "isLoggedIn"))
    }
    
    
    func testGoalCreation() throws {
        let goal = Goal(context: context)
        goal.title = "Test Goal"
        goal.progress = 0.5
        
        try context.save()
        
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        let goals = try context.fetch(fetchRequest)
        
        XCTAssertEqual(goals.count, 1)
        XCTAssertEqual(goals.first?.title, "Test Goal")
        XCTAssertEqual(goals.first?.progress, 0.5)
    }
    
    // MARK: - Habits Tests
    func testHabitCreation() throws {
        let habit = Habit(context: context)
        habit.name = "Test Habit"
        habit.isCompleted = false
        
        try context.save()
        
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        let habits = try context.fetch(fetchRequest)
        
        XCTAssertEqual(habits.count, 1)
        XCTAssertEqual(habits.first?.name, "Test Habit")
        XCTAssertFalse(habits.first?.isCompleted ?? true)
    }
    

    
    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
