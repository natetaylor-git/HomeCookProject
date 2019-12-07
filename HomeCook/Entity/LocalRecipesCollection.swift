//
//  LocalRecipes.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol LocalRecipesCollectionProtocol {
    var localRecipes: LocalRecipesCollection { get }
}

class LocalRecipesCollection {
    static var shared: LocalRecipesCollection = {
        let localRecipes = LocalRecipesCollection()
        return localRecipes
    }()
    
    var dict = [Int: DetailedRecipeEntity]()
    let userDefaultsService: UserDefaultsServiceProtocol
    
    private init() {
        self.userDefaultsService = UserDefaultsService()
    }
    
    func updateUserDefaults() {
        let updatedIds = Set<Int>(self.dict.keys)
        let result = self.userDefaultsService.saveSet(set: updatedIds)
        if  result == false {
            print("can't save current recipe ids to user defaults")
            return
        }
    }
}

extension LocalRecipesCollection: LocalRecipesCollectionProtocol {
    var localRecipes: LocalRecipesCollection {
        return LocalRecipesCollection.shared
    }
}


//class LocalRecipesCollection {
//    static var shared: LocalRecipesCollection = {
//        let localRecipes = LocalRecipesCollection()
//        return localRecipes
//    }()
//
//    var idList = Set<Int>()
//    private let queue = DispatchQueue(label: "com.cacheQueue", attributes: .concurrent)
//    private var collection = [DetailedRecipeEntity]()
//
//    public func append(_ element: DetailedRecipeEntity) {
//        self.queue.async(flags: .barrier) {
//            self.collection.append(element)
//            self.idList.insert(element.recipe.id)
//        }
//    }
//
//    public func removeAll(){
//        self.queue.async(flags: .barrier) {
//            self.collection.removeAll()
//            self.idList.removeAll()
//        }
//    }
//
//    public func removeAtIndex(index: Int) {
//        self.queue.async(flags:.barrier) {
//            self.collection.remove(at: index)
//            self.idList.remove(self.collection[index].recipe.id)
//        }
//    }
//
//    public var count: Int {
//        var count = 0
//
//        self.queue.sync {
//            count = self.collection.count
//        }
//
//        return count
//    }
//
//    public subscript(index: Int) -> DetailedRecipeEntity {
//        get {
//            var item = DetailedRecipeEntity()
//            self.queue.sync {
//                item = self.collection[index]
//            }
//            return item
//        }
//
//        set (newModel) {
//            queue.async(flags: .barrier) {
//                self.collection[index] = newModel
//            }
//        }
//    }
//}
