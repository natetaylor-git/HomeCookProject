//
//  BoughtIngredientsCollection.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 09/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

protocol BoughtIngredientsCollectionProtocol {
    var localRecipes: BoughtIngredientsCollection { get }
}

class BoughtIngredientsCollection {
    static var shared: BoughtIngredientsCollection = {
        let localRecipes = BoughtIngredientsCollection()
        return localRecipes
    }()
    
    var recipeIds = Set<Int>()
    var summary = [String: IngredientModel]()
    let userDefaultsService: UserDefaultsServiceProtocol
    
    private init() {
        self.userDefaultsService = UserDefaultsService()
    }
    
    func updateUserDefaults() {
        let updatedIds = Set<String>(self.summary.keys)
        let key = self.userDefaultsService.boughtIngredientsKey
        let result = self.userDefaultsService.saveSet(set: updatedIds, key: key)
        if  result == false {
            print("can't save ingredient bought labels to user defaults")
            return
        }
    }
}

extension BoughtIngredientsCollection: BoughtIngredientsCollectionProtocol {
    var localRecipes: BoughtIngredientsCollection {
        return BoughtIngredientsCollection.shared
    }
}
