//
//  NSManagedObjectContext+Utils.swift
//  TivBible
//
//  Created by Isaac Iniongun on 31/05/2023.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func saveChanges() {
        if hasChanges {
            do {
                try save()
            } catch {
                debugPrint("Unable to save changes")
                debugPrint(error)
            }
        }
    }
    
    func fetchByID<T: NSManagedObject>(objectType: T.Type, id: UUID) throws -> T? {
        let predicate = NSPredicate(format: "id = %@", id as CVarArg)
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        
        let objects = try fetch(request) as? [T]
        
        return objects?.first
    }
    
    func objects<T: NSManagedObject>(for objectType: T.Type,
                                     predicate: NSPredicate? = nil,
                                     sortDescriptors: [NSSortDescriptor]? = nil
    ) throws -> [T] {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        return try fetch(request) as? [T] ?? []
    }
}
