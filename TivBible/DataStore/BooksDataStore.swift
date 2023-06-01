//
//  DataStore.swift
//  TivBible
//
//  Created by Isaac Iniongun on 31/05/2023.
//

import Foundation
import CoreData

final class BooksDataStore: NSObject, ObservableObject {
    
    static let shared = BooksDataStore()
    static let preview = BooksDataStore(type: .preview)
    static let testing = BooksDataStore(type: .testing)
    
    @Published var books: [Book] = []
    
    fileprivate var context: NSManagedObjectContext
    fileprivate var container: NSPersistentContainer
    private let booksFRC: NSFetchedResultsController<BookMO>
    
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
        
        let bookFR: NSFetchRequest<BookMO> = BookMO.fetchRequest()
        bookFR.sortDescriptors = []
        booksFRC = NSFetchedResultsController(fetchRequest: bookFR,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        
        super.init()
        
        booksFRC.delegate = self
        
        fetchBooks()
    }
    
    private func updateBooks(_ bookMOs: [BookMO]) {
        books = bookMOs.books
    }
    
    func fetchBooks(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        if let predicate = predicate {
            booksFRC.fetchRequest.predicate = predicate
        }
        
        if let sortDescriptors = sortDescriptors {
            booksFRC.fetchRequest.sortDescriptors = sortDescriptors
        }
        
        try? booksFRC.performFetch()
        
        if let bookMOs = booksFRC.fetchedObjects {
            updateBooks(bookMOs)
        }
    }
    
    func insertBooks(_ books: [Book]) async throws {
        guard books.isNotEmpty else { return }
        
        try await container.performBackgroundTask { context in
            let batchInsert = self.booksBatchInsertRequest(books)
            try context.execute(batchInsert)
        }
    }
    
    private func booksBatchInsertRequest(_ books: [Book]) -> NSBatchInsertRequest {
        var index = 0
        let total = books.count
        
        let batchInsertRequest = NSBatchInsertRequest(entity: BookMO.entity()) { (managedObject: NSManagedObject) -> Bool in
            guard index < total else { return true }
            
            if var bookMO = managedObject as? BookMO {
                with(books[index]) {
                    bookMO.id = $0.id
                    bookMO.name = $0.name
                    bookMO.order = $0.order.int16
                    bookMO.version = $0.version.int16
                    bookMO.testament = $0.testament.int16
                    bookMO.chapters = NSSet(array: $0.chapters)
                }
            }
            
            index += 1
            return false
        }
        
        return batchInsertRequest
    }
}

extension BooksDataStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let bookMOs = controller.fetchedObjects as? [BookMO] {
            updateBooks(bookMOs)
        }
    }
}
