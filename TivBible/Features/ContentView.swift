//
//  ContentView.swift
//  TivBible
//
//  Created by Isaac Iniongun on 30/05/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        Text("Take this")
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
