//
//  SplashView.swift
//  TivBible
//
//  Created by Isaac Iniongun on 02/06/2023.
//

import SwiftUI

struct SplashView: View {
    
    @StateObject private var viewModel = SplashViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
