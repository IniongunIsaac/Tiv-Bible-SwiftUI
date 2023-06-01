//
//  Verse.swift
//  TivBible
//
//  Created by Isaac Iniongun on 30/05/2023.
//

import Foundation
import CoreData

struct Verse: Identifiable {
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
        try? context.fetchByID(objectType: VerseMO.self, id: id) ?? newVerseMO(context: context)
    }
    
    func newVerseMO(context: NSManagedObjectContext) -> VerseMO {
        let verseMO = VerseMO(context: context)
        verseMO.id = id
        verseMO.number = number.int16
        verseMO.title = title
        verseMO.text = text
        
        if let chapterId = chapter?.id {
            verseMO.chapter = try? context.fetchByID(objectType: ChapterMO.self, id: chapterId)
        }
        
        return verseMO
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
