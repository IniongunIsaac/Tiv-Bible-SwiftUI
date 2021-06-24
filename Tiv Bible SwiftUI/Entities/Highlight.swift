//
//  Highlight.swift
//  Tiv Bible SwiftUI
//
//  Created by Isaac Iniongun on 18/06/2021.
//

import Foundation
import RealmSwift

@objcMembers class Highlight: Object, ObjectKeyIdentifiable {
    dynamic var highlightedOn = Date()
    dynamic var colorName: String?
    dynamic var book: Book?
    dynamic var chapter: Chapter?
    dynamic var verse: Verse?
    dynamic var compositePrimaryKey = ""
    
    override static func primaryKey() -> String? {
        return "compositePrimaryKey"
    }
    
    var bookNameAndChapterNumberAndVerseNumberString: String {
        return "\(book!.name) \(chapter!.chapterNumber) \(verse!.number)"
    }
    
    convenience required init(book: Book, chapter: Chapter, verse: Verse, colorName: String) {
        self.init()
        self.book = book
        self.chapter = chapter
        self.verse = verse
        self.colorName = colorName
        compositePrimaryKey = "\(self.book!.id)_\(self.chapter!.id)_\(self.verse!.number)"
    }
    
}
