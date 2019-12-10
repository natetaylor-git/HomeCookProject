//
//  BoughtIngredientsCollection.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 09/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

protocol IngredientsCollectionProtocol {
    var collection: IngredientsCollection { get }
    func getCurrentIngredientsSummary(localRecipesCollection: LocalRecipesCollectionProtocol) -> [String: IngredientBuyModel]
}

class IngredientsCollection {
    static var shared: IngredientsCollection = {
        let localRecipes = IngredientsCollection()
        return localRecipes
    }()
    
    var recipeIds = Set<Int>()
    var summary = [String: IngredientBuyModel]()
    let userDefaultsService: UserDefaultsServiceProtocol
    
    private init() {
        self.userDefaultsService = UserDefaultsService()
    }
    
//    func updateUserDefaults() {
//        let updatedIds = Set<String>(self.summary.keys)
//        let key = self.userDefaultsService.boughtIngredientsKey
//        let result = self.userDefaultsService.saveSet(set: updatedIds, key: key)
//        if  result == false {
//            print("can't save ingredient bought labels to user defaults")
//            return
//        }
//    }
    
    func getCurrentIngredientsSummary(localRecipesCollection: LocalRecipesCollectionProtocol) -> [String: IngredientBuyModel] {
        var summary = [String: IngredientBuyModel]()
        
        for recipe in localRecipesCollection.localRecipes.dict {
            for ingredient in recipe.value.recipe.ingredients {
                let name = ingredient.name
                let unit = ingredient.unit
                let amount = ingredient.amount
                let oldAmount = summary[name]?.amount ?? 0
                let newAmount = oldAmount + amount
                summary[name] = IngredientBuyModel(name: name, amount: newAmount, unit: unit, amountBoughtStatus: newAmount)
            }
        }

        return summary
    }
}

extension IngredientsCollection: IngredientsCollectionProtocol {
    var collection: IngredientsCollection {
        return IngredientsCollection.shared
    }
}
