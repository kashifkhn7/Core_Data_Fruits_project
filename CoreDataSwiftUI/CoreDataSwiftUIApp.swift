//
//  CoreDataSwiftUIApp.swift
//  CoreDataSwiftUI
//
//  Created by MUHAMMAD KASHIF on 05/11/2022.
//

import SwiftUI

@main
struct CoreDataSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
