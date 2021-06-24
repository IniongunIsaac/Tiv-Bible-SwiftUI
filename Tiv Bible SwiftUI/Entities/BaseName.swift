//
//  BaseName.swift
//  Tiv Bible SwiftUI
//
//  Created by Isaac Iniongun on 18/06/2021.
//

import Foundation

@objcMembers class BaseName: Base {
    dynamic var name = ""
    
    convenience required init(name: String) {
        self.init()
        self.name = name
    }
}
