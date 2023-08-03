//
//  CoreDataCampApp.swift
//  CoreDataCamp
//
//  Created by Travis Okonicha on 03/08/2023.
//

import SwiftUI

@main
struct CoreDataCampApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
