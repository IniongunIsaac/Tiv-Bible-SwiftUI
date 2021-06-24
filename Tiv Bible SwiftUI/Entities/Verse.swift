//
//  Verse.swift
//  Tiv Bible SwiftUI
//
//  Created by Isaac Iniongun on 18/06/2021.
//

import Foundation
import RealmSwift

@objcMembers class Verse: Base {
    dynamic var number = 0
    dynamic var text = ""
    dynamic var hasTitle = false
    dynamic var title = ""
    dynamic var isSelected = false
    dynamic var isHighlighted = false
    dynamic var highlight: Highlight?
    
    let chapters = LinkingObjects(fromType: Chapter.self, property: "verses")
    var chapter: Chapter {
        return chapters.first!
    }
    
    override static func ignoredProperties() -> [String] {
        return ["isSelected", "isHighlighted", "highlight"]
    }
    
    convenience required init(number: Int, text: String, hasTitle: Bool, title: String) {
        self.init()
        self.number = number
        self.text = text
        self.hasTitle = hasTitle
        self.title = title
    }
    
}
