//
//  Book.swift
//  TivBible
//
//  Created by Isaac Iniongun on 30/05/2023.
//

import Foundation
import CoreData

struct Book {
    var id: UUID = UUID()
    var name: String
    var order: Int
    var testament: Int
    var version: Int
    var chapters: [Chapter] = []
}

extension Book {
    init(bookMO: BookMO) {
        id = bookMO.id ?? UUID()
        name = bookMO.name ?? ""
        order = bookMO.order.int
        testament = bookMO.testament.int
        version = bookMO.version.int
        if let chapterMOs = bookMO.chapters as? Set<ChapterMO> {
            chapters = chapterMOs.map(Chapter.init)
        }
    }
}

extension BookMO {
    var book: Book {
        Book(bookMO: self)
    }
}

extension Array where Element == BookMO {
    var books: [Book] {
        map(Book.init)
    }
}
