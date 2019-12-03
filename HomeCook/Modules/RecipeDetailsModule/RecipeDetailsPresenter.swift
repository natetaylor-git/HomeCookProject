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
//        let recipeInfo = recipeObject.recipe
        if let image = UIImage(data: imageData) {
            self.view?.updateImageView(with: image)
        }
        
    }
}

extension RecipeDetailsPresenter: RecipeDetailsPresenterInputProtocol {
    func viewLoaded() {
        self.interactor?.getRecipeInfo()
    }
}
