//
//  Dog_TrackinApp.swift
//  Dog Trackin
//
//  Created by Luke Busch on 3/19/26.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct Dog_TrackinApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(AuthViewModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
