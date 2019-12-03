//
//  RecipeDetailedConfigurator.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class RecipeDetailsConfigurator: RecipeDetailsConfiguratorProtocol {
    func configure(with viewController: RecipeDetailsViewController, recipeEntity: DetailedRecipeEntity?) {
        let presenter = RecipeDetailsPresenter()
        let interactor = RecipeDetailsInteractor()
        interactor.recipeEntity = recipeEntity
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewController
    }
}
