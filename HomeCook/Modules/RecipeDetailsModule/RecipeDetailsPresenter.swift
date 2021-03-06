//
//  RecipeDetailedPresenter.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class RecipeDetailsPresenter: RecipeDetailsInteractorOutputProtocol {
    var interactor: RecipeDetailsInteractorInputProtocol?
    weak var view: RecipeDetailsPresenterOutputProtocol?
    
    func prepareInfo(about recipeObject: DetailedRecipeEntity) {
        let imageData = recipeObject.recipeImageData
        let recipeInfo = recipeObject.recipe
        
        if let image = UIImage(data: imageData) {
            self.view?.setupImageView(with: image)
        }
        
        let stringMinutes = String(recipeInfo.readyTimeMin)
        let infoForView = [(name: "Name", value: recipeInfo.name),
                           (name: "Course", value: recipeInfo.course),
                           (name: "Cuisine", value: recipeInfo.cousine),
                           (name: "Time in minutes", value: stringMinutes),
                           (name: "Instructions", value: recipeInfo.instructions),
                           (name: "Ingredients", value: "List:")]
        
        self.view?.setupDetailsViews(with: infoForView)
        self.view?.setupIngredientsView(with: recipeInfo.ingredients)
    }
    
    /// Method that tells view to update activate ui elements if recipe was found in local storage
    func updateUIForEntityExistedInLocalStorage() {
        self.view?.activateUIElementsForEntityExistance()
    }
    
}

extension RecipeDetailsPresenter: RecipeDetailsPresenterInputProtocol {
    func viewLoaded() {
        self.interactor?.getRecipeInfo()
        self.interactor?.checkExistanceOfRecipeEntity()
    }
    
    func buyButtonActive() {
        self.interactor?.addRecipeToLocalStorage()
    }
    
    func buyButtonNotActive() {
        self.interactor?.deleteRecipeFromLocalStorageIfExists()
    }
}
