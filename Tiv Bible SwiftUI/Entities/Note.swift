//
//  Note.swift
//  Tiv Bible SwiftUI
//
//  Created by Isaac Iniongun on 18/06/2021.
//

import Foundation
import RealmSwift

@objcMembers class Note: Base {
    dynamic var takenOn = Date()
    dynamic var comment = ""
    dynamic var book: Book?
    dynamic var chapter: Chapter?
    let verses = List<Verse>()
    
    convenience required init(comment: String, book: Book, chapter: Chapter) {
        self.init()
        self.comment = comment
        self.book = book
        self.chapter = chapter
    }
    
    var bookNameAndChapterNumberAndVerseNumbersString: String {
        return "\(book!.name) \(chapter!.chapterNumber):\(formattedVerseNumbers)"
    }
    
    var formattedVersesText: String {
        return verses.sorted { $0.number < $1.number }.map { "\($0.number).\t\($0.text)" }.joined(separator: "\n")
    }
    
    var formattedVerseNumbers: String {
        
        var left: Int?
        var right: Int?
        var groups = [String]()
        let verseNumbers = verses.sorted { $0.number < $1.number }.map { $0.number }
        
        for index in (verseNumbers.first ?? 0)...(verseNumbers.last ?? 0) + 1 {
            if verseNumbers.contains(index) {
                if left == nil {
                    left = index
                } else {
                    right = index
                }
            } else {
                guard let leftx = left else { continue }
                
                if let right = right {
                    groups.append("\(leftx)-\(right)")
                } else {
                    groups.append("\(leftx)")
                }
                left = nil
                right = nil
            }
        }
        
        return groups.joined(separator: ", ")
        
    }
}
