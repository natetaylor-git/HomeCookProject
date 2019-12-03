//
//  SearchInteractor.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class SearchInteractor: SearchInteractorInputProtocol {
    let networkService: NetworkServiceInputProtocol
    weak var presenter: SearchInteractorOutputProtocol?
    
    var searchRecipes: RecipesCollection
    var oneSearchRecipes: RecipesCollection
    var searchRecipesImages: ImagesCollection
    var sameSearchRecipesTotalAmount = 0
    var currentSearchText = ""
    var newSearch = true

//    var entity: DetailedRecipeEntity = DetailedRecipeEntity()
    
    init(networkService: NetworkServiceInputProtocol) {
        self.networkService = networkService
        self.searchRecipes = RecipesCollection(with: [])
        self.oneSearchRecipes = RecipesCollection(with: [])
        self.searchRecipesImages = ImagesCollection()
    }
    
    func getDetailedRecipe(for recipeIndex: Int) {
        let recipe = searchRecipes[recipeIndex]
        var imageData = Data()
        if let data = self.searchRecipesImages.imagesDict[recipe.id] {
            imageData = data
        }
        let detailedRecipeEntity = DetailedRecipeEntity(model: recipe, imageData: imageData)
        self.presenter?.callViewCompletion(with: detailedRecipeEntity)
    }
    
    func setSearchRecipes(_ models: [RecipeDownloadModel]) {
        guard let modelSearch = models.first?.searchRequest,
            self.currentSearchText == modelSearch else {
            return
        }
        
        if self.newSearch {
            self.sameSearchRecipesTotalAmount = 0
            self.searchRecipes.removeAll()
        }
        
        self.oneSearchRecipes.removeAll()
        
        for downloadModel in models {
            let recipeModel = RecipeModel(downloadModel)
            self.oneSearchRecipes.append(recipeModel)
            self.searchRecipes.append(recipeModel)
        }
        self.presenter?.setRecipes(oneSearchRecipes)
        self.setSearchRecipesImages(models)
    }
    
    func setSearchRecipesImages(_ models: [RecipeDownloadModel]) {
        let baseIndex = self.sameSearchRecipesTotalAmount
        for (index, model) in models.enumerated() {
            let absoluteIndex = baseIndex + index
            if let imageData = self.searchRecipesImages.imagesDict[model.id] {
                self.presenter?.setImage(for: absoluteIndex, with: imageData)
                self.sameSearchRecipesTotalAmount += 1
                continue
            }
            
            self.loadImage(at: model.imagePath) { data in
                guard let modelSearch = model.searchRequest,
                    self.currentSearchText == modelSearch else {
                    return
                }
                self.searchRecipesImages.imagesDict[model.id] = data
                self.presenter?.setImage(for: absoluteIndex, with: data)
                self.sameSearchRecipesTotalAmount += 1
            }
        }
    }
    
    func loadImage(at path: String, completion: @escaping (Data?) -> Void) {
        let url = API.getImageUrl(relativePath: path)
        self.networkService.getData(at: url) { data in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(data)
        }
    }
//    
//    func setSearchRecipeImage(for recipeId: Int, with data: Data) {
//        self.searchRecipesImages?.imagesDict[recipeId] = data
//        self.presenter?.setImage(for: recipeId, with: data)
//    }
//    
    func loadRecipes(by searchString: String, sameSearch: Bool) {
        var offset: Int = 0
        if sameSearch {
            offset = self.sameSearchRecipesTotalAmount// self.searchRecipes.count
        } else {
            self.currentSearchText = searchString
        }
        
        let url = API.getRecipes(searchString: self.currentSearchText, offset: offset)
        self.networkService.getData(at: url) { data in
            guard let data = data else {
                return
            }
            
            let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: .init()) as? Dictionary<String, Any>
            
            guard let response = responseDictionary,
                let content = response["data"] as? Dictionary<String, Any>,
                let recipes = content["recipes"] as? [[String: Any]] else {
                    return
            }
            
            let models = recipes.map { (object) -> RecipeDownloadModel in
                let stringId = object["id"] as? String ?? "0"
                let id = Int(stringId) ?? 0
                let imageRelativePath = object["image"] as? String ?? ""
                let name = object["name"] as? String ?? ""
                return RecipeDownloadModel(searchRequest: searchString, id: id, name: name, imagePath: imageRelativePath, course: nil, cousine: nil, readyTimeMin: nil, instructions: nil, ingredients: nil)
            }
            
            self.newSearch = !sameSearch
            self.setSearchRecipes(models)
        }
    }
}
