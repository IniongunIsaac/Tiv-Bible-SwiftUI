//
//  VerseDataStore.swift
//  TivBible
//
//  Created by Isaac Iniongun on 31/05/2023.
//

import Foundation
import CoreData

final class VersesDataStore: NSObject, ObservableObject {
    static let shared = VersesDataStore()
    static let preview = VersesDataStore(type: .preview)
    static let testing = VersesDataStore(type: .testing)
    
    @Published var verses: [Verse] = []
    
    fileprivate var context: NSManagedObjectContext
    fileprivate var container: NSPersistentContainer
    private let versesFRC: NSFetchedResultsController<VerseMO>
    
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
        
        let verseFR: NSFetchRequest<VerseMO> = VerseMO.fetchRequest()
        verseFR.sortDescriptors = []
        versesFRC = NSFetchedResultsController(fetchRequest: verseFR,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        
        super.init()
        
        versesFRC.delegate = self
        
        fetchVerses()
    }
    
    private func updateVerses(_ verseMOs: [VerseMO]) {
        verses = verseMOs.verses
    }
    
    func fetchVerses(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        if let predicate = predicate {
            versesFRC.fetchRequest.predicate = predicate
        }
        
        if let sortDescriptors = sortDescriptors {
            versesFRC.fetchRequest.sortDescriptors = sortDescriptors
        }
        
        try? versesFRC.performFetch()
        
        if let verseMOs = versesFRC.fetchedObjects {
            updateVerses(verseMOs)
        }
    }
    
    func insertVerses(_ verses: [Verse]) async throws {
        guard verses.isNotEmpty else { return }
        
        try await container.performBackgroundTask { context in
            let batchInsert = self.versesBatchInsertRequest(verses)
            try context.execute(batchInsert)
        }
    }
    
    private func versesBatchInsertRequest(_ verses: [Verse]) -> NSBatchInsertRequest {
        var index = 0
        let total = verses.count
        
        let batchInsertRequest = NSBatchInsertRequest(entity: VerseMO.entity()) { (managedObject: NSManagedObject) -> Bool in
            guard index < total else { return true }
            
            if let verseMO = managedObject as? VerseMO {
                with(verses[index]) {
                    verseMO.id = $0.id
                    verseMO.number = $0.number.int16
                    verseMO.title = $0.title
                    verseMO.text = $0.text
                    //verseMO.chapter = $0.chapter?.chapterMO(context: self.context)
                }
            }
            
            index += 1
            return false
        }
        
        return batchInsertRequest
    }
}

extension VersesDataStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let verseMOs = controller.fetchedObjects as? [VerseMO] {
            updateVerses(verseMOs)
        }
    }
}
