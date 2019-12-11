//
//  RecipeModel.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

struct RecipeDownloadModel {
    var searchRequest: String?
    let id: Int
    let name: String
    let imagePath: String
}

struct RecipeModel {
    let id: Int
    let name: String
    let course: String
    let cousine: String
    let readyTimeMin: Int
    let instructions: String
    let ingredients: [IngredientModel]
    
    init(id: Int, name: String, course: String, cuisine: String, readyTimeMin: Int, instructions: String, ingredients: [IngredientModel]) {
        self.id = id
        self.name = name
        self.course = course
        self.cousine = cuisine
        self.readyTimeMin = readyTimeMin
        self.instructions = instructions
        self.ingredients = ingredients
    }
    
    init(_ downloadModel: RecipeDownloadModel) {
        self.id = downloadModel.id
        self.name = downloadModel.name
        self.course = ""
        self.cousine = ""
        self.readyTimeMin = 0
        self.instructions = ""
        self.ingredients = []
    }
    
    init() {
        self.id = -1
        self.name = ""
        self.course = ""
        self.cousine = ""
        self.readyTimeMin = 0
        self.instructions = ""
        self.ingredients = [IngredientModel]()
    }
}

struct RecipeCellModel {
    let id: Int
    let name: String
    var image: UIImage?
}

struct IngredientModel {
    let name: String
    var amount: Int
    let unit: String
}

struct IngredientBuyModel {
    let name: String
    var amount: Int
    let unit: String
    var amountBoughtStatus: Int
    
    init(ingredient: IngredientModel) {
        self.name = ingredient.name
        self.amount = ingredient.amount
        self.unit = ingredient.unit
        self.amountBoughtStatus = ingredient.amount
    }
    
    init(name: String, amount: Int, unit: String, amountBoughtStatus: Int) {
        self.name = name
        self.amount = amount
        self.unit = unit
        self.amountBoughtStatus = amountBoughtStatus
    }
}

struct RecipeImage {
    let id: Int
    let image: UIImage
}
