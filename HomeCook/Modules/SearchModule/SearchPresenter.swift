//
//  SearchPresenter.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class SearchPresenter: SearchInteractorOutputProtocol {
    
    var interactor: SearchInteractorInputProtocol?
    weak var view: SearchPresenterOutputProtocol?
//    weak var localRecipes: LocalRecipesCollection?
//    weak var localImages: LocalImagesCollection?
    
    func setRecipes(_ models: RecipesCollection) {
        var recipesCellModels = [RecipeCellModel]()
        for index in 0..<models.count {
            let recipeModel = models[index]
            let cellModel = RecipeCellModel(name: recipeModel.name, image: nil)
            recipesCellModels.append(cellModel)
        }
        
        DispatchQueue.main.async {
            self.view?.updateResults(with: recipesCellModels)
        }
    }
    
    func setImage(for recipeId: Int, with data: Data?) {
        guard let data = data, let image = UIImage(data: data) else {
            return
        }
        
        let indexPath = IndexPath(row: recipeId, section: 0)
        
        DispatchQueue.main.async {
            self.view?.updateResult(at: indexPath, with: image)
        }
    }
    
    func callViewCompletion(with detailedRecipe: DetailedRecipeEntity) {
        self.view?.callCompletion(with: detailedRecipe)
    }
}

extension SearchPresenter: SearchPresenterInputProtocol {
    func viewLoaded() {
        self.interactor?.loadRecipes(by: "", sameSearch: false)
    }
    
    func clickedOnCell(at indexPath: IndexPath) {
        let recipeIndex = indexPath.row
        self.interactor?.getDetailedRecipe(for: recipeIndex)
    }
    
    func prefetchCalled() {
        self.interactor?.loadRecipes(by: "", sameSearch: true)
    }
    
    func searchButtonClicked(with searchText: String?) {
        guard let text = searchText else {
            return
        }
        self.interactor?.loadRecipes(by: text, sameSearch: false)
    }
    
//    func getTableViewSourceCount() -> Int {
//        return localRecipes?.count ?? 0
//    }
//
//    func getItemForCell(at indexPath: IndexPath) -> RecipeCellModel {
//        var text: String = ""
//        var image = UIImage()
//
//        //вылетело - поменял
//        guard let recipe = localRecipes?[indexPath.row] else {
//            return RecipeCellModel(name: text, image: image)
//        }
//
//        text = recipe.name
//        let id = recipe.id
//        guard let recipeImage = localImages?.imagesDict[id] else {
//            return RecipeCellModel(name: text, image: image)
//        }
//
//        image = recipeImage
//        let model = RecipeCellModel(name: text, image: image)
//        return model
//    }
}
