//
//  RecipeDetailedProtocols.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol RecipeDetailsConfiguratorProtocol: class {
    func configure(with viewController: RecipeDetailsViewController, recipeEntity: DetailedRecipeEntity?)
}

protocol RecipeDetailsPresenterInputProtocol: class {
    func viewLoaded()
}

protocol RecipeDetailsPresenterOutputProtocol: class {
    func updateImageView(with image: UIImage)
}

protocol RecipeDetailsInteractorInputProtocol: class {
    func getRecipeInfo()
}

protocol RecipeDetailsInteractorOutputProtocol: class {
    func prepareInfo(about recipeObject: DetailedRecipeEntity)
}
