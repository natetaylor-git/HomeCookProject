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
    
    func checkExistanceOfRecipeEntity() {
        if self.localRecipesCollection.localRecipes.dict[recipeEntity.recipe.id] != nil {
            self.presenter?.updateUIForEntityExistedInLocalStorage()
        }
    }
    
    func getRecipeInfo() {
        self.presenter?.prepareInfo(about: self.recipeEntity)
    }
    
    func addRecipeToLocalStorage() {
        self.localRecipesCollection.localRecipes.dict[recipeEntity.recipe.id] = recipeEntity
//        let core = CoreDataService()
//        core.deleteAllRecipes(completion: {lol in })
//        core.saveRecipes()
//        core.loadRecipes { (a) in
//            
//        }
    }
    
    func deleteRecipeFromLocalStorageIfExists() {
        self.localRecipesCollection.localRecipes.dict.removeValue(forKey: recipeEntity.recipe.id)
    }
}
