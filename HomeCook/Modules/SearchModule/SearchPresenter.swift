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
    
    func setRecipes(_ models: RecipesCollection) {
        var recipesCellModels = [RecipeCellModel]()
        for index in 0..<models.count {
            let recipeModel = models[index]
            let cellModel = RecipeCellModel(id: recipeModel.id, name: recipeModel.name, image: nil)
            recipesCellModels.append(cellModel)
        }
        
        DispatchQueue.main.async {
            self.view?.updateResults(with: recipesCellModels)
        }
    }
    
    func setImage(for recipeId: Int, with data: Data?) {
        var imageToSet: UIImage
        if let data = data, let image = UIImage(data: data) {
            imageToSet = image
        } else {
            if let emptyImage = UIImage(named: "Empty") {
                imageToSet = emptyImage
            } else {
                return
            }
        }
        
        let indexPath = IndexPath(row: recipeId, section: 0)
        
        DispatchQueue.main.async {
            self.view?.updateResult(at: indexPath, with: imageToSet)
        }
    }
    
    func setFiltersParameters(with parameters: [String: FilterParameters]) {
        var formattedParameters = [(String, [String], String)]()
        let sortedParameters = parameters.sorted(by: { filter1, filter2 in
            return filter1.value.id < filter2.value.id
        })
        
        for filterParameter in sortedParameters {
            let valueNames = filterParameter.value.values.map {$0.val}
            let current = filterParameter.value.getCurrent().val
            formattedParameters.append((filterParameter.value.name + ":", valueNames, current))
        }
        
        DispatchQueue.main.async {
            self.view?.updateFiltersView(with: formattedParameters)
        }
    }
    
    func callViewCompletion(with detailedRecipe: DetailedRecipeEntity) {
        self.view?.callCompletion(with: detailedRecipe)
    }
    
    func clearExistedResults() {
        self.view?.clearCurrentResults()
    }
}

extension SearchPresenter: SearchPresenterInputProtocol {
    func viewLoaded() {
        self.interactor?.loadRecipes(by: "", sameSearch: false)
        self.interactor?.loadFiltersValues() // поменять местами?!
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
    
    func filtersClosed(with parameters: [(name: String?, value: String?)]) {
        var formattedParameters = [(name: String?, value: String?)]()
        for parameter in parameters {
            let name = parameter.name ?? ""
            formattedParameters.append((String(name.dropLast()), parameter.value))
        }
        
        self.interactor?.updateFiltersValues(formattedParameters)
    }
}
