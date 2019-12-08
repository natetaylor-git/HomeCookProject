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
    let filtersStorage: FilterParametersStorageProtocol
    
    init(networkService: NetworkServiceInputProtocol,
         filtersStorage: FilterParametersStorageProtocol) {
        self.networkService = networkService
        self.filtersStorage = filtersStorage
        
        self.searchRecipes = RecipesCollection(with: [])
        self.oneSearchRecipes = RecipesCollection(with: [])
        self.searchRecipesImages = ImagesCollection()
    }
    
    func updateFiltersValues(_ parameters: [(name: String?, value: String?)]) {
        var needToUpdate = false
        for oneFilterParameters in parameters {
            let name = oneFilterParameters.name ?? ""
            let chosenValue = oneFilterParameters.value ?? "All"
            if let filter = self.filtersStorage.collection[name],
                filter.currentIsEqualTo(value: chosenValue) == false {
                filter.setCurrent(called: chosenValue)
                needToUpdate = true
            }
        }
        
        if needToUpdate {
            self.updateSearch()
        }
    }
    
    func updateSearch() {
        self.searchRecipes.removeAll()
        self.oneSearchRecipes.removeAll()
        self.presenter?.clearExistedResults()
        self.loadRecipes(by: currentSearchText, sameSearch: false)
    }
    
    func loadFiltersValues() {
        let filterLoadingGroup = DispatchGroup()
        
        for filter in self.filtersStorage.collection.values {
            if filter.type == .manyValues && filter.isEmpty() {
                filterLoadingGroup.enter()
                loadOneFilterValues(for: filter.name) { values in
                    guard let newValues = values else {
                        filterLoadingGroup.leave()
                        return
                    }
                    
                    filter.values.append(contentsOf: newValues)
                    filterLoadingGroup.leave()
                }
            }
        }
        
        filterLoadingGroup.notify(queue: DispatchQueue.main) {
            self.presenter?.setFiltersParameters(with: self.filtersStorage.collection)
        }
    }
    
    func loadOneFilterValues(for filterName: String, completion: @escaping ([ParameterValue]?) -> ()) {
        var url: URL
        var dataNameFromAPI: String = ""
        
        switch filterName {
        case "Cuisine type":
            url = API.getCuisineFilterValues()
            dataNameFromAPI = "cousines"
        case "Course type":
            url = API.getCourseFilterValues()
            dataNameFromAPI = "courseTypes"
        default:
            completion(nil)
            return
        }
        
        self.networkService.getData(at: url) { data in
            guard let data = data else {
                completion(nil)
                return
            }
            let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: .init()) as? Dictionary<String, Any>
            
            guard let response = responseDictionary,
                let content = response["data"] as? Dictionary<String, Any>,
                let currentFilterContent = content[dataNameFromAPI] as? Array<Dictionary<String, Any>> else {
                    completion(nil)
                    return
            }
            
            var values = [ParameterValue]()
            for valueObject in currentFilterContent {
                let name = valueObject["name"] as? String ?? ""
                let stringId = valueObject["id"] as? String ?? "0"
                let id = Int(stringId) ?? 0
                
                values.append(ParameterValue(id: id, val: name))
            }
            completion(values)
        }
    }
    
    func setSearchRecipes(_ models: [RecipeDownloadModel]) {
        if models.count == 0 {
            self.presenter?.setRecipes(RecipesCollection())
            return
        }
        
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
        guard let url = API.getImageUrl(relativePath: path) else {
            completion(nil)
            return
        }
        self.networkService.getData(at: url) { data in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(data)
        }
    }
    
    func loadRecipes(by searchString: String, sameSearch: Bool) {
        var offset: Int = 0
        if sameSearch {
            offset = self.sameSearchRecipesTotalAmount
        } else {
            self.currentSearchText = searchString
        }
        
        let cuisineId = self.filtersStorage.collection["Cuisine type"]?.getCurrent().id ?? 0
        let courseId = self.filtersStorage.collection["Course type"]?.getCurrent().id ?? 0
        let maxMinute = Int(self.filtersStorage.collection["Maximum time"]?.getCurrent().val ?? "0") ?? 0

        let url = API.getRecipes(searchString: self.currentSearchText, offset: offset, maxTime: maxMinute, cuisineId: cuisineId, courseTypeId: courseId)
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
                return RecipeDownloadModel(searchRequest: searchString, id: id, name: name, imagePath: imageRelativePath, course: "", cousine: "", readyTimeMin: 0, instructions: "", ingredients: [])
            }
            
            self.newSearch = !sameSearch
            self.setSearchRecipes(models)
        }
    }
    
    func getDetailedRecipe(for recipeIndex: Int) {
        let recipe = self.searchRecipes[recipeIndex]
        var imageData = Data()
        if let data = self.searchRecipesImages.imagesDict[recipe.id] {
            imageData = data
        }
        loadOneRecipeInfo(by: recipe.id) { (model) in
            guard let model = model else {
                return
            }
            let detailedRecipeEntity = DetailedRecipeEntity(model: model, imageData: imageData)
            DispatchQueue.main.async {
                self.presenter?.callViewCompletion(with: detailedRecipeEntity)
            }
        }
    }
    
    func loadOneRecipeInfo(by id: Int, completion: @escaping (RecipeModel?) -> ()) {
        let url = API.getRecipeInfo(id: id)
        self.networkService.getData(at: url) { data in
            guard let data = data else {
                completion(nil)
                return
            }

            let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: .init()) as? Dictionary<String, Any>

            guard let response = responseDictionary,
                let content = response["data"] as? Dictionary<String, Any>,
                let recipe = content["recipe"] as? Dictionary<String, Any>,
                let courseDict = recipe["courseType"] as? Dictionary<String, Any>,
                let cuisineDict = recipe["cousine"] as? Dictionary<String, Any>,
                let ingredientsArray = recipe["recipeIngridients"] as? Array<Dictionary<String, Any>> else {
                    completion(nil)
                    return
            }
            
            var ingredients = [IngredientModel]()
            for globalIngredient in ingredientsArray {
                guard let unit = globalIngredient["unit"] as? Dictionary<String, Any>,
                    let ingredient = globalIngredient["ingridient"] as? Dictionary<String, Any> else {
                        completion(nil)
                        return
                }
                
                let ingredientUnit = unit["name"] as? String ?? ""
                let ingredientName = ingredient["name"] as? String ?? ""
                let ingredientAmount = globalIngredient["amount"] as? Int ?? 0
                
                let ingredientModel = IngredientModel(name: ingredientName, amount: ingredientAmount, unit: ingredientUnit)
                ingredients.append(ingredientModel)
            }
            
            let name = recipe["name"] as? String ?? ""
            let instructions = recipe["instructions"] as? String ?? ""
            let minutes = recipe["readyInTime"] as? Int ?? 0
            let course = courseDict["name"] as? String ?? ""
            let cuisine = cuisineDict["name"] as? String ?? ""
            
            let recipeInfo = RecipeModel(id: id, name: name, course: course, cuisine: cuisine, readyTimeMin: minutes, instructions: instructions, ingredients: ingredients)

            completion(recipeInfo)
        }
    }
}
