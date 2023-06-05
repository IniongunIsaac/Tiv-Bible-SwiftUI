//
//  ContentView.swift
//  TivBible
//
//  Created by Isaac Iniongun on 30/05/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @StateObject private var viewModel = SplashViewModel()

    var body: some View {
        Text("Next up!!!")
            .onAppear {
                viewModel.printBooks()
            }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
