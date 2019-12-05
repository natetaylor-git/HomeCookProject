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
    let course: String
    let cousine: String
    let readyTimeMin: Int
    let instructions: String
    let ingredients: [IngredientModel]
}

struct RecipeModel {
    let id: Int
    let name: String
    let course: String
    let cousine: String
    let readyTimeMin: Int
    let instructions: String
    let ingredients: [IngredientModel]
    
    init(_ downloadModel: RecipeDownloadModel) {
        self.id = downloadModel.id
        self.name = downloadModel.name
        self.course = downloadModel.course
        self.cousine = downloadModel.cousine
        self.readyTimeMin = downloadModel.readyTimeMin
        self.instructions = downloadModel.instructions
        self.ingredients = downloadModel.ingredients
    }
    
    init(id: Int, name: String, course: String, cuisine: String, readyTimeMin: Int, instructions: String, ingredients: [IngredientModel]) {
        self.id = id
        self.name = name
        self.course = course
        self.cousine = cuisine
        self.readyTimeMin = readyTimeMin
        self.instructions = instructions
        self.ingredients = ingredients
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
    let amount: Int
    let unit: String
}

struct RecipeImage {
    let id: Int
    let image: UIImage
}
