//
//  TivBibleApp.swift
//  TivBible
//
//  Created by Isaac Iniongun on 30/05/2023.
//

import SwiftUI

@main
struct TivBibleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
