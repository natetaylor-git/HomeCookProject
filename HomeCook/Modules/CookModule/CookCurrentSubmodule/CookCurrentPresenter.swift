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
    
}

extension CookCurrentPresenter: CookCurrentInteractorOutputProtocol {
    
    func takeCurrentRecipes(_ recipes: LocalRecipesCollectionProtocol) {
        var recipesInfoToShow = [(name: String, image: UIImage, instructions: String)]()
        let sortedRecipes = recipes.localRecipes.dict.sorted{ $0.0 < $1.0 }
        
        for recipe in sortedRecipes {
            let recipeValue = recipe.value
            let image = UIImage(data: recipeValue.recipeImageData) ?? UIImage()
            let recipeInfo = (name: recipeValue.recipe.name,
                              image: image,
                              instructions: recipeValue.recipe.instructions)
            recipesInfoToShow.append(recipeInfo)
        }
        self.view?.updateCollectionView(with: recipesInfoToShow)
    }
}
