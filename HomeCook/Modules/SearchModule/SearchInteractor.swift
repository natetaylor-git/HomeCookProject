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
    
    /// Method that updates filters if needed and asks to update search results
    ///
    /// - Parameter parameters: current values of filters
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
    
    /// Method that removes all existed search results and asks to load new search results
    func updateSearch() {
        self.searchRecipes.removeAll()
        self.oneSearchRecipes.removeAll()
        self.presenter?.clearExistedResults()
        self.loadRecipes(by: currentSearchText, sameSearch: false)
    }
    
    /// Method that asks to load all available values for filters
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
    
    /// Method that loads all available values for specific filter
    ///
    /// - Parameters:
    ///   - filterName: name of filter to be setted with available loaded values
    ///   - completion: passes loaded filter values
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
    
    /// Method that updates current search results, passes data to presenter and asks to download
    /// images for downloaded recipes
    ///
    /// - Parameter models: donloaded recipes models
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
            self.searchRecipes.removeAll()
        }
        
        self.oneSearchRecipes.removeAll()
        
        for downloadModel in models {
            let recipeModel = RecipeModel(downloadModel)
            self.oneSearchRecipes.append(recipeModel)
            self.searchRecipes.append(recipeModel)
        }
        self.presenter?.setRecipes(oneSearchRecipes)
        
        self.setSearchRecipesImages(models, baseIndex: self.searchRecipes.count - models.count)
    }
    
    /// Method that passes loaded images of recipes to presenter
    ///
    /// - Parameters:
    ///   - models: downloaded recipe models with recipe ids
    ///   - baseIndex: index in collection of search results equal to recipe index
    func setSearchRecipesImages(_ models: [RecipeDownloadModel], baseIndex: Int) {
        for (index, model) in models.enumerated() {
            let absoluteIndex = baseIndex + index
            if let imageData = self.searchRecipesImages.imagesDict[model.id] {
                self.presenter?.setImage(for: absoluteIndex, with: imageData)
                continue
            }
            
            self.loadImage(at: model.imagePath) { data in
                guard let modelSearch = model.searchRequest,
                    self.currentSearchText == modelSearch else {
                    return
                }
                self.searchRecipesImages.imagesDict[model.id] = data
                self.presenter?.setImage(for: absoluteIndex, with: data)
            }
        }
    }
    
    /// Method that loads one image for specific recipe by url
    ///
    /// - Parameters:
    ///   - path: path from downloaded recipe model that is used to create url for image loading
    ///   - completion: passes image data
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
    
    /// Method that loads recipes by given search string
    ///
    /// - Parameters:
    ///   - searchString: key words that recipe name should contain
    ///   - sameSearch: parameter that tells about current search state
    func loadRecipes(by searchString: String, sameSearch: Bool) {
        var offset: Int = 0
        let batchSize = API.batchSize
        
        if sameSearch {
            offset = self.sameSearchRecipesTotalAmount
            self.sameSearchRecipesTotalAmount += batchSize
        } else {
            self.sameSearchRecipesTotalAmount = batchSize
            self.currentSearchText = searchString
        }
        
        let searchRequest = self.currentSearchText
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
                return RecipeDownloadModel(searchRequest: searchRequest, id: id, name: name, imagePath: imageRelativePath)
            }
            
            self.newSearch = !sameSearch
            self.setSearchRecipes(models)
        }
    }
    
    /// Method that passes detailed recipe model to presenter
    ///
    /// - Parameter recipeIndex: recipe index in search results collection
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
    
    /// Method that loads data for specific recipe
    ///
    /// - Parameters:
    ///   - id: recipe id
    ///   - completion: passes recipe model with loaded data
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
