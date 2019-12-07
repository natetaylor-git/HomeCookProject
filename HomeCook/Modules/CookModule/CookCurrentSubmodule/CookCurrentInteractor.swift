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
    
    private var existingLocalRecipesIds: Set<Int>
    private var needUpdate = false
    
    init(localCollection: LocalRecipesCollectionProtocol, coreDataService: CoreDataServiceProtocol) {
        self.localRecipesCollection = localCollection
        self.coreDataService = coreDataService
        self.existingLocalRecipesIds = Set<Int>(self.localRecipesCollection.localRecipes.dict.keys)
    }
    
    func getCurrentRecipes() {
        if self.localRecipesCollection.localRecipes.dict.count > 0 || needUpdate {
            self.presenter?.takeCurrentRecipes(localRecipesCollection)
        }
    }
    
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
    
    func deleteRecipeFromLocalStorage(id: Int) {
        let cookedRecipe = self.localRecipesCollection.localRecipes.dict.removeValue(forKey: id)
        self.localRecipesCollection.localRecipes.updateUserDefaults()
        if let recipeForHistory = cookedRecipe {
            self.coreDataService.saveRecipes([id: recipeForHistory])
        }
        
        checkIfLocalRecipesUpdated()
    }
}
