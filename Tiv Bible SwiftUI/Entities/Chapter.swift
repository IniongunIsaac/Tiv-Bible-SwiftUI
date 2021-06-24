//
//  Chapter.swift
//  Tiv Bible SwiftUI
//
//  Created by Isaac Iniongun on 18/06/2021.
//

import Foundation
import RealmSwift

@objcMembers class Chapter: Base {
    dynamic var chapterNumber = 0
    dynamic var numberOfVerses = 0
    dynamic var isSelected = false
    var verses = List<Verse>()
    
    let books = LinkingObjects(fromType: Book.self, property: "chapters")
    var book: Book {
        return books.first!
    }
    
    override static func ignoredProperties() -> [String] {
        return ["isSelected"]
    }
    
    convenience required init(chapterNumber: Int, numberOfVerses: Int) {
        self.init()
        self.chapterNumber = chapterNumber
        self.numberOfVerses = numberOfVerses
    }
    
}
