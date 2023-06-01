//
//  ChapterDataStore.swift
//  TivBible
//
//  Created by Isaac Iniongun on 31/05/2023.
//

import Foundation
import CoreData

final class ChaptersDataStore: NSObject, ObservableObject {
    static let shared = ChaptersDataStore()
    static let preview = ChaptersDataStore(type: .preview)
    static let testing = ChaptersDataStore(type: .testing)
    
    @Published var chapters: [Chapter] = []
    
    fileprivate var context: NSManagedObjectContext
    fileprivate var container: NSPersistentContainer
    private let chaptersFRC: NSFetchedResultsController<ChapterMO>
    
    private init(type: DataStoreType = .normal) {
        switch type {
        case .normal:
            let persistentStore = PersistentStore()
            self.context = persistentStore.context
            self.container = persistentStore.container
        case .preview, .testing:
            let persistentStore = PersistentStore(inMemory: true)
            self.context = persistentStore.context
            self.container = persistentStore.container
        }
        
        let chapterFR: NSFetchRequest<ChapterMO> = ChapterMO.fetchRequest()
        chapterFR.sortDescriptors = []
        chaptersFRC = NSFetchedResultsController(fetchRequest: chapterFR,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        
        super.init()
        
        chaptersFRC.delegate = self
        
        fetchChapters()
    }
    
    private func updateChapters(_ chapterMOs: [ChapterMO]) {
        chapters = chapterMOs.chapters
    }
    
    func fetchChapters(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        if let predicate = predicate {
            chaptersFRC.fetchRequest.predicate = predicate
        }
        
        if let sortDescriptors = sortDescriptors {
            chaptersFRC.fetchRequest.sortDescriptors = sortDescriptors
        }
        
        try? chaptersFRC.performFetch()
        
        if let chapterMOs = chaptersFRC.fetchedObjects {
            updateChapters(chapterMOs)
        }
    }
    
    func insertChapters(_ chapters: [Chapter]) async throws {
        guard chapters.isNotEmpty else { return }
        
        try await container.performBackgroundTask { context in
            let batchInsert = self.chaptersBatchInsertRequest(chapters)
            try context.execute(batchInsert)
        }
    }
    
    private func chaptersBatchInsertRequest(_ chapters: [Chapter]) -> NSBatchInsertRequest {
        var index = 0
        let total = chapters.count
        
        let batchInsertRequest = NSBatchInsertRequest(entity: ChapterMO.entity()) { (managedObject: NSManagedObject) -> Bool in
            guard index < total else { return true }
            
            if let chapterMO = managedObject as? ChapterMO {
                with(chapters[index]) {
                    chapterMO.id = $0.id
                    chapterMO.number = $0.number.int16
                    /*chapterMO.book = $0.book?.bookMO(context: self.context)
                    let verseMOs = $0.verses.compactMap { $0.verseMO(context: self.context) }
                    chapterMO.verses = NSSet(array: verseMOs)*/
                }
            }
            
            index += 1
            return false
        }
        
        return batchInsertRequest
    }
}

extension ChaptersDataStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let chapterMOs = controller.fetchedObjects as? [ChapterMO] {
            updateChapters(chapterMOs)
        }
    }
}
