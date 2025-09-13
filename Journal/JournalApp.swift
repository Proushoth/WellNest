//
//  JournalApp.swift
//  Journal
//
//  Created by proushoth koushal on 8/19/25.
//

import SwiftUI

@main
struct JournalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


