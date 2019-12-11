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
 
    /// Method that checks userDefaults settings and tells presenter if hint needed
    func checkIfHintIsNeeded() {
        let hintIsNeeded = self.userDefaultsService.checkStatusOfHintForBuyScreen()
        if hintIsNeeded {
            self.presenter?.hintNeeded()
        }
    }
    
    /// Method that turns hint off by userDefaults service
    func turnHintOff(){
        self.userDefaultsService.setHintStatusToNotNeeded()
    }
    
    /// Method that saves actual information about bought ingredients
    ///
    /// - Parameter ingredients: names of bought ingredients
    func saveBoughtIngredients(ingredients: Set<String>) {
        if self.userDefaultsService.saveSet(set: ingredients, key: self.boughtUDKey) == false {
            print("can't save bought labels")
        }
    }
    
    /// Method that creates summary for all ingredients depending on existing local recipes
    /// ingredients and last ingredients summary
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
        
        self.ingredientsCollection.collection.summary = newSummary
        self.presenter?.takeIngredients(summarized: newSummary, boughtLabels: boughtIngredients)
    }
    
    
    /// Method that returns current summary for all ingredients
    ///
    /// - Returns: current ingredients summary (last used)
    func getCurrentIngredientsSummary() -> [String: IngredientBuyModel] {
        let result = self.ingredientsCollection.getCurrentIngredientsSummary(localRecipesCollection: self.localRecipesCollection)
        return result
    }
    
    /// Method that loads info about bought ingredients by userDefaults service
    ///
    /// - Returns: names of bought ingredients
    func getBoughtLabels() -> Set<String> {
        let labels: Set<String> = self.userDefaultsService.getSet(key: self.boughtUDKey) ?? Set()
        return labels
    }
}
