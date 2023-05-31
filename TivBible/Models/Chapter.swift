//
//  Chapter.swift
//  TivBible
//
//  Created by Isaac Iniongun on 30/05/2023.
//

import Foundation
import CoreData

struct Chapter {
    var id: UUID = UUID()
    var number: Int
    var verses: [Verse] = []
    var book: Book?
}

extension Chapter {
    init(chapterMO: ChapterMO) {
        id = chapterMO.id ?? UUID()
        number = Int(chapterMO.number)
        book = chapterMO.book?.book
        if let verseMOs = chapterMO.verses as? Set<VerseMO> {
            verses = verseMOs.map(Verse.init)
        }
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
