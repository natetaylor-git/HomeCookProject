//
//  RecipeDetailedInteractor.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class RecipeDetailsInteractor: RecipeDetailsInteractorInputProtocol {
    weak var presenter: RecipeDetailsInteractorOutputProtocol?
    var recipeEntity: DetailedRecipeEntity
    var localRecipesCollection: LocalRecipesCollectionProtocol
    
    init(recipeEntity: DetailedRecipeEntity, localRecipesCollection: LocalRecipesCollectionProtocol) {
        self.recipeEntity = recipeEntity
        self.localRecipesCollection = localRecipesCollection
    }
    
    /// Method that checks if recipe exists in local storage
    func checkExistanceOfRecipeEntity() {
        if self.localRecipesCollection.localRecipes.dict[recipeEntity.recipe.id] != nil {
            self.presenter?.updateUIForEntityExistedInLocalStorage()
        }
    }
    
    /// Method that passes holded recipe data to presenter
    func getRecipeInfo() {
        self.presenter?.prepareInfo(about: self.recipeEntity)
    }
    
    /// Method that saves holded recipe entity to local storage
    func addRecipeToLocalStorage() {
        self.localRecipesCollection.localRecipes.dict[recipeEntity.recipe.id] = recipeEntity
        self.localRecipesCollection.localRecipes.updateUserDefaults()
    }
    
    /// Method that deletes recipe from local storage if it exists
    func deleteRecipeFromLocalStorageIfExists() {
        self.localRecipesCollection.localRecipes.dict.removeValue(forKey: recipeEntity.recipe.id)
        self.localRecipesCollection.localRecipes.updateUserDefaults()
    }
}
