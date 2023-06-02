//
//  TivBibleApp.swift
//  TivBible
//
//  Created by Isaac Iniongun on 30/05/2023.
//

import SwiftUI

@main
struct TivBibleApp: App {
    
    init() {
        setupDependencyContainer()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

private extension TivBibleApp {
    func setupDependencyContainer() {
        /*DependencyContainer.register(type: BooksDataStore.self, as: .singleton, BooksDataStore.shared)
        DependencyContainer.register(type: ChaptersDataStore.self, as: .singleton, ChaptersDataStore.shared)
        DependencyContainer.register(type: VersesDataStore.self, as: .singleton, VersesDataStore.shared)*/
    }
}
