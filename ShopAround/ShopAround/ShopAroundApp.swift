//
//  ShopAroundApp.swift
//  ShopAround
//
//  Created by Kyle Szklenski on 8/11/24.
//

import SwiftUI
import SwiftData

@main
struct ShopAroundApp: App {
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Cat.self, isAutosaveEnabled: true)
                .onAppear {
                    Task {
                        let actor = CatActor(modelContainer: try! ModelContainer(for: Cat.self))
                        await actor.createDatabaseIfNotExists()
                    }
                }
        }
    }
}
