//
//  CookCurrentPresenter.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class CookCurrentPresenter: CookCurrentPresenterInputProtocol {
    var interactor: CookCurrentInteractorInputProtocol?
    weak var view: CookCurrentPresenterOutputProtocol?
    
    func viewLoaded() {
        self.interactor?.getCurrentRecipes()
    }
    
    func viewWillAppear() {
        self.interactor?.checkIfLocalRecipesUpdated()
    }
    
    func clickedDoneButton(recipeId: Int) {
        self.interactor?.deleteRecipeFromLocalStorage(id: recipeId)
    }
}

extension CookCurrentPresenter: CookCurrentInteractorOutputProtocol {
    /// Method that passes current recipes to view with instructions and image
    ///
    /// - Parameter recipes: collection of current recipes
    func takeCurrentRecipes(_ recipes: LocalRecipesCollectionProtocol) {
        var recipesInfoToShow = [(id:Int, name: String, image: UIImage, instructions: String)]()
        let sortedRecipes = recipes.localRecipes.dict.sorted{ $0.0 < $1.0 }
        
        for recipe in sortedRecipes {
            let recipeValue = recipe.value
            let image = UIImage(data: recipeValue.recipeImageData) ?? UIImage()
            let recipe = recipeValue.recipe
            let recipeInfo = (id: recipe.id,
                              name: recipe.name,
                              image: image,
                              instructions: recipe.instructions)
            recipesInfoToShow.append(recipeInfo)
        }
        self.view?.updateCollectionView(with: recipesInfoToShow)
    }
}
