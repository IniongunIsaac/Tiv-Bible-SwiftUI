//
//  History.swift
//  Tiv Bible SwiftUI
//
//  Created by Isaac Iniongun on 18/06/2021.
//

import Foundation
import RealmSwift

@objcMembers class History: Object, ObjectKeyIdentifiable {
    dynamic var historyDate = Date()
    dynamic var book: Book?
    dynamic var chapter: Chapter?
    dynamic var compositePrimaryKey = ""
    
    override static func primaryKey() -> String? { "compositePrimaryKey" }
    
    var bookNameAndChapterNumber: String { "\(book!.bookName) \(chapter!.chapterNumber)" }
    
    convenience required init(book: Book, chapter: Chapter) {
        self.init()
        self.book = book
        self.chapter = chapter
        compositePrimaryKey = "\(self.chapter!.id)"
    }
    
}
