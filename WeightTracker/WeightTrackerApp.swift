//
//  WeightTrackerApp.swift
//  WeightTracker
//
//  Created by Florian Thiévent on 12.07.21.
//

import SwiftUI

@main
struct WeightTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
