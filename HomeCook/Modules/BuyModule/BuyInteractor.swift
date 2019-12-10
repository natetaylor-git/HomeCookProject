//
//  BuyInteractor.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class BuyInteractor: BuyInteractorInputProtocol {
    weak var presenter: BuyInteractorOutputProtocol?
    let userDefaultsService: UserDefaultsServiceProtocol
    var localRecipesCollection: LocalRecipesCollectionProtocol
    var ingredientsSum = [String: IngredientModel]()
    var ingredientsCollection: IngredientsCollectionProtocol
    let boughtUDKey: String
    
    init(userDefaultsService: UserDefaultsServiceProtocol, localCollection: LocalRecipesCollectionProtocol, ingredientsCollection: IngredientsCollectionProtocol) {
        self.userDefaultsService = userDefaultsService
        self.localRecipesCollection = localCollection
        self.ingredientsCollection = ingredientsCollection
        self.boughtUDKey = self.userDefaultsService.boughtIngredientsKey
    }
 
    func checkIfHintIsNeeded() {
        let hintIsNeeded = self.userDefaultsService.checkStatusOfHintForBuyScreen()
        if hintIsNeeded {
            self.presenter?.hintNeeded()
        }
    }
    
    func turnHintOff(){
        self.userDefaultsService.setHintStatusToNotNeeded()
    }
    
    func saveBoughtIngredients(ingredients: Set<String>) {
        if self.userDefaultsService.saveSet(set: ingredients, key: self.boughtUDKey) == false {
            print("can't save bought labels")
        }
    }
    
    func getIngredientsSummary() {
        var boughtIngredients = getBoughtLabels()
        
        let currentRecipesIngredientsSummary = getCurrentIngredientsSummary()
        let oldSummary = self.ingredientsCollection.collection.summary
        var newSummary = [String: IngredientBuyModel]()
        
        for ingredient in oldSummary {
            let name = ingredient.value.name
            let unit = ingredient.value.unit
            let key = ingredient.key
            let oldAmount = ingredient.value.amount
            
            var newAmount: Int
            var boughtAmount: Int
            if let currentRecipesIngredient = currentRecipesIngredientsSummary[key] {
                let currentRecipesIngredientAmount = currentRecipesIngredient.amount
                newAmount = currentRecipesIngredientAmount
                boughtAmount = currentRecipesIngredientAmount
                if currentRecipesIngredientAmount > oldAmount {
                    boughtIngredients.remove(key)
                }
                if currentRecipesIngredientAmount < oldAmount {
                    boughtAmount = currentRecipesIngredientAmount - oldAmount
                }
            } else {
                if boughtIngredients.contains(key) {
                    boughtAmount = -oldAmount
                    newAmount = 0
                } else {
                    continue
                }
            }
            
            newSummary[key] = IngredientBuyModel(name: name, amount: newAmount, unit: unit, amountBoughtStatus: boughtAmount)
        }
        
        let toAdd = Set<String>(currentRecipesIngredientsSummary.keys).subtracting(oldSummary.keys)
        
        for key in toAdd {
            newSummary[key] = currentRecipesIngredientsSummary[key]
        }
        
//        for ingredient in currentRecipesIngredientsSummary {
//            if toAdd.contains(ingredient.key) {
//                newSummary[ingredient.key] = ingredient.value
//            }
//        }
        
        self.ingredientsCollection.collection.summary = newSummary
        self.presenter?.takeIngredients(summarized: newSummary, boughtLabels: boughtIngredients)
        
        
//        let recipesIds = Set<Int>(self.localRecipesCollection.localRecipes.dict.keys)
//        let recipesIdsOld = self.ingredientsCollection.collection.recipeIds
//        let recipesIdsToAddFromCurrent = recipesIds.subtracting(recipesIdsOld)
//
//        for recipeId in recipesIdsToAddFromCurrent {
//            if let newRecipe = self.localRecipesCollection.localRecipes.dict[recipeId] {
//                for ingredient in newRecipe.recipe.ingredients {
//                    let key = ingredient.name
//                    if newSummary.keys.contains(key) == false {
//                        let ingredientToAdd = IngredientBuyModel(ingredient: ingredient)
//                        newSummary[key] = ingredientToAdd
//                    }
//                }
//            }
//        }
    }
    
    func getCurrentIngredientsSummary() -> [String: IngredientBuyModel] {
        let result = self.ingredientsCollection.getCurrentIngredientsSummary(localRecipesCollection: self.localRecipesCollection)
        return result
        
//        var summary = [String: IngredientModel]()
//
//        for recipe in self.localRecipesCollection.localRecipes.dict {
//            for ingredient in recipe.value.recipe.ingredients {
//                let name = ingredient.name
//                let unit = ingredient.unit
//                let amount = ingredient.amount
//                let oldAmount = summary[name]?.amount ?? 0
//                let newAmount = oldAmount + amount
//                summary[name] = IngredientModel(name: name, amount: newAmount, unit: unit)
//            }
//        }
//
//        return summary
    }
    
    func getBoughtLabels() -> Set<String> {
        let labels: Set<String> = self.userDefaultsService.getSet(key: self.boughtUDKey) ?? Set()
        return labels
    }
}
