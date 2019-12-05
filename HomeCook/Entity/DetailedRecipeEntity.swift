//
//  Entities.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class DetailedRecipeEntity {
    var recipe: RecipeModel
    var recipeImageData: Data
    
    init(model: RecipeModel, imageData: Data) {
        self.recipe = model
        self.recipeImageData = imageData
    }
    
    init() {
        self.recipe = RecipeModel()
        self.recipeImageData = Data()
    }
}
