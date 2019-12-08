//
//  SearchProtocols.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol SearchConfiguratorProtocol: class {
    func configure(with viewController: SearchViewController)
}

protocol SearchPresenterInputProtocol: class {
    func viewLoaded()
    func searchButtonClicked(with searchText: String?)
    func prefetchCalled()
    func clickedOnCell(at indexpath: IndexPath)
    func filtersClosed(with parameters: [(name: String?, value: String?)])
}

protocol SearchPresenterOutputProtocol: class {
    func updateResults(with recipesCellModels: [RecipeCellModel])
    func updateResult(at indexPath: IndexPath, with image: UIImage)
    func updateFiltersView(with parameters: [(String, [String], String)])
    func callCompletion(with detailedRecipe: DetailedRecipeEntity)
    func clearCurrentResults()
}

protocol SearchInteractorInputProtocol: class {
    func loadRecipes(by searchString: String, sameSearch: Bool)
    func loadImage(at path: String, completion: @escaping (Data?) -> Void)
    func getDetailedRecipe(for recipeIndex: Int)
    func loadFiltersValues()
    func updateFiltersValues(_ parameters: [(name: String?, value: String?)])
}

protocol SearchInteractorOutputProtocol: class {
    func setRecipes(_ models: RecipesCollection)
    func setImage(for recipeId: Int, with data: Data?)
    func setFiltersParameters(with parameters: [String: FilterParameters])
    func callViewCompletion(with detailedRecipe: DetailedRecipeEntity)
    func clearExistedResults()
}
