//
//  Chapter.swift
//  TivBible
//
//  Created by Isaac Iniongun on 30/05/2023.
//

import Foundation
import CoreData

struct Chapter: Identifiable {
    var id: UUID = UUID()
    var number: Int
    var bookID: UUID
    var verseIDs = [UUID]()
    /*var verses: [Verse] = []
    var book: Book?*/
}

extension Chapter {
    init(chapterMO: ChapterMO) {
        id = chapterMO.id ?? UUID()
        number = chapterMO.number.int
        bookID = chapterMO.id ?? UUID()
        if let verseMOs = chapterMO.verses as? Set<VerseMO> {
            verseIDs = verseMOs.compactMap { $0.id }
        }
        /*book = chapterMO.book?.book
        if let verseMOs = chapterMO.verses as? Set<VerseMO> {
            verses = verseMOs.map(Verse.init)
        }*/
    }
    
    func chapterMO(context: NSManagedObjectContext) -> ChapterMO? {
        try? context.fetchByID(objectType: ChapterMO.self, id: id) ?? newChapterMO(context: context)
    }
    
    func newChapterMO(context: NSManagedObjectContext) -> ChapterMO {
        let chapterMO = ChapterMO(context: context)
        chapterMO.id = id
        chapterMO.number = number.int16
        chapterMO.book = try? context.fetchByID(objectType: BookMO.self, id: bookID)
        
        let verseMOs = verseIDs.compactMap { try? context.fetchByID(objectType: VerseMO.self, id: $0) }
        chapterMO.verses = NSSet(array: verseMOs)
        
        /*chapterMO.book = book?.bookMO(context: context)
        let verseMOs = verses.compactMap { $0.verseMO(context: context) }
        chapterMO.verses = NSSet(array: verseMOs)*/
        return chapterMO
    }
}

extension ChapterMO {
    var chapter: Chapter {
        Chapter(chapterMO: self)
    }
}

extension Array where Element == ChapterMO {
    var chapters: [Chapter] {
        map(Chapter.init)
    }
}
