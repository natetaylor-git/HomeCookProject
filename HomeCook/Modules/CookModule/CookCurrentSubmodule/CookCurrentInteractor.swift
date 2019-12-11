//
//  CookCurrentInteractor.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class CookCurrentInteractor: CookCurrentInteractorInputProtocol {
    weak var presenter: CookCurrentInteractorOutputProtocol?
    var localRecipesCollection: LocalRecipesCollectionProtocol
    let coreDataService: CoreDataServiceProtocol
    let userDefaultsService: UserDefaultsServiceProtocol
    
    private var existingLocalRecipesIds: Set<Int>
    private var historyRecipesIds = Set<Int>()
    private var needUpdate = false
    
    init(localCollection: LocalRecipesCollectionProtocol, coreDataService: CoreDataServiceProtocol, userDefaultsService: UserDefaultsServiceProtocol) {
        self.userDefaultsService = userDefaultsService
        self.localRecipesCollection = localCollection
        self.coreDataService = coreDataService
        self.existingLocalRecipesIds = Set<Int>(self.localRecipesCollection.localRecipes.dict.keys)
    }
    
    func getCurrentRecipes() {
        if self.localRecipesCollection.localRecipes.dict.count > 0 || needUpdate {
            self.presenter?.takeCurrentRecipes(localRecipesCollection)
        }
    }
    
    /// Method that checks if any recipes were cooked and current recipes need to be updated
    func checkIfLocalRecipesUpdated() {
        let currentRecipesIds = Set<Int>(self.localRecipesCollection.localRecipes.dict.keys)
        if self.existingLocalRecipesIds != currentRecipesIds {
            self.needUpdate = true
            self.existingLocalRecipesIds = currentRecipesIds
            self.getCurrentRecipes()
        } else {
            self.needUpdate = false
        }
    }
    
    /// Method that deletes cooked recipes from current recipes (local storage)
    ///
    /// - Parameter id: recipe id
    func deleteRecipeFromLocalStorage(id: Int) {
        let cookedRecipe = self.localRecipesCollection.localRecipes.dict.removeValue(forKey: id)
        self.localRecipesCollection.localRecipes.updateUserDefaults()
        if let recipeForHistory = cookedRecipe {
            self.coreDataService.saveRecipes([id: recipeForHistory])
            self.historyRecipesIds.insert(id)
            
            let userDefaultsHistoryKey = self.userDefaultsService.historyKey
            let existedHistory: Set<Int>? = self.userDefaultsService.getSet(key: userDefaultsHistoryKey)
            
            if let existedHistory = existedHistory {
                self.historyRecipesIds = self.historyRecipesIds.union(existedHistory)
            }
            
            if self.userDefaultsService.saveSet(set: self.historyRecipesIds, key: userDefaultsHistoryKey) == false {
                print("can't write history recipes id")
            }
        }
        
        checkIfLocalRecipesUpdated()
    }
}
