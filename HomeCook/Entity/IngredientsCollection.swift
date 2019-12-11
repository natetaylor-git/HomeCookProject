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

/// Collection of ingredients used to store ingredients data shown at buy screen while app is active
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
    
    /// Method that returns collection of ingredients with summarized amount
    ///
    /// - Parameter localRecipesCollection: current recipes that are chosen by user
    /// - Returns: dictionary that contains summarized ingredients with names as keys
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
