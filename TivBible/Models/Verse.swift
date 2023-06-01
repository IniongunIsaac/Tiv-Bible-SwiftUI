//
//  Verse.swift
//  TivBible
//
//  Created by Isaac Iniongun on 30/05/2023.
//

import Foundation
import CoreData

struct Verse {
    var id: UUID = UUID()
    var title: String
    var text: String
    var number: Int
    var chapter: Chapter?
}

extension Verse {
    init(verseMO: VerseMO) {
        id = verseMO.id ?? UUID()
        title = verseMO.title ?? ""
        text = verseMO.text ?? ""
        number = verseMO.number.int
        chapter = verseMO.chapter?.chapter
    }
    
    func verseMO(context: NSManagedObjectContext) -> VerseMO? {
        try? context.fetchByID(objectType: VerseMO.self, id: id)
    }
}

extension VerseMO {
    var verse: Verse {
        Verse(verseMO: self)
    }
}

extension Array where Element == VerseMO {
    var verses: [Verse] {
        map(Verse.init)
    }
}
