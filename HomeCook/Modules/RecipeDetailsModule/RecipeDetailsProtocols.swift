//
//  RecipeDetailedProtocols.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol RecipeDetailsConfiguratorProtocol: class {
    func configure(with viewController: RecipeDetailsViewController, recipeEntity: DetailedRecipeEntity)
}

protocol RecipeDetailsPresenterInputProtocol: class {
    func viewLoaded()
    func buyButtonActive()
    func buyButtonNotActive()
}

protocol RecipeDetailsPresenterOutputProtocol: class {
    func setupImageView(with image: UIImage)
    func setupDetailsViews(with infoDetails: [(name: String, value: String)])
    func activateUIElementsForEntityExistance()
}

protocol RecipeDetailsInteractorInputProtocol: class {
    func getRecipeInfo()
    func addRecipeToLocalStorage()
    func deleteRecipeFromLocalStorageIfExists()
    func checkExistanceOfRecipeEntity()
}

protocol RecipeDetailsInteractorOutputProtocol: class {
    func prepareInfo(about recipeObject: DetailedRecipeEntity)
    func updateUIForEntityExistedInLocalStorage()
}
