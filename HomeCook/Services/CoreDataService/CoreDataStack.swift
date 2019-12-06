//
//  CoreDataStack.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation
import CoreData

internal final class CoreDataStack {
    static let shared: CoreDataStack = {
        let coreDataStack = CoreDataStack()
        return coreDataStack
    }()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        let group = DispatchGroup()
        
        persistentContainer = NSPersistentContainer(name: "HomeCookModel")
        group.enter()
        
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            group.leave()
        }
        group.wait()
    }
}
