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

/// Collection of recipes used to store chosen recipes while app is active
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
