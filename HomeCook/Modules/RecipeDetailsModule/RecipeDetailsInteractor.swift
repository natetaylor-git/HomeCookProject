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
    var recipeEntity: DetailedRecipeEntity?
    
    func getRecipeInfo() {
        guard let recipe = recipeEntity else {
            return
        }
        self.presenter?.prepareInfo(about: recipe)
    }
}
