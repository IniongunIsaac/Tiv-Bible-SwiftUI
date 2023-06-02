//
//  DependencyProvider.swift
//  TivBible
//
//  Created by Isaac Iniongun on 02/06/2023.
//

import Foundation

@propertyWrapper
struct Provided<Service> {
    
    var service: Service
    
    init(as dependencyType: DependencyType = .newInstance) {
        guard let service = DependencyContainer.resolve(Service.self, as: dependencyType) else {
            fatalError("No dependency of type \(String(describing: Service.self)) registered!")
        }
        
        self.service = service
    }
    
    var wrappedValue: Service {
        get { self.service }
        mutating set { service = newValue }
    }
}
