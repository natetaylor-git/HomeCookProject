//
//  CookHistoryInteractor.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class CookHistoryInteractor: CookHistoryInteractorInputProtocol {
    weak var presenter: CookHistoryInteractorOutputProtocol?
    let coreDataService: CoreDataServiceProtocol
    private var recipesFromDataBase: [Int: DetailedRecipeEntity]
    
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
        self.recipesFromDataBase = [:]
    }
    
    func getHistory() {
        self.coreDataService.loadRecipes(completion: { models in
            if models.count != 0 {
                self.recipesFromDataBase = models
                self.presenter?.takeHistory(Array(models.values))
            }
        })
    }
    
    func getDetailedRecipe(id: Int) {
        guard let recipeDetails = recipesFromDataBase[id] else {
            return
        }
        self.presenter?.takeRecipeInfo(recipeDetails)
    }
    
}
