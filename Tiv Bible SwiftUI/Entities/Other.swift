//
//  Other.swift
//  Tiv Bible SwiftUI
//
//  Created by Isaac Iniongun on 18/06/2021.
//

import Foundation

@objcMembers class Other: Base {
    dynamic var title = ""
    dynamic var subTitle = ""
    dynamic var text = ""
    
    convenience required init(title: String, subTitle: String, text: String) {
        self.init()
        self.title = title
        self.subTitle = subTitle
        self.text = text
    }
    
}
