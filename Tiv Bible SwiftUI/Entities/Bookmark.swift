//
//  Bookmark.swift
//  Tiv Bible SwiftUI
//
//  Created by Isaac Iniongun on 18/06/2021.
//

import Foundation
import RealmSwift

@objcMembers class Bookmark: Object, ObjectKeyIdentifiable {
    dynamic var bookmarkedOn = Date()
    dynamic var book: Book?
    dynamic var chapter: Chapter?
    dynamic var verse: Verse?
    dynamic var compositePrimaryKey = ""
    
    override static func primaryKey() -> String? { "compositePrimaryKey" }
    
    var bookNameAndChapterNumberAndVerseNumberString: String { "\(book!.name) \(chapter!.chapterNumber) \(verse!.number)" }
    
    convenience required init(book: Book, chapter: Chapter, verse: Verse) {
        self.init()
        self.book = book
        self.chapter = chapter
        self.verse = verse
        compositePrimaryKey = "\(self.book!.id)_\(self.chapter!.id)_\(self.verse!.number)"
    }
    
}
