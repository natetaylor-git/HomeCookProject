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
    let userDefaultsService: UserDefaultsServiceProtocol
    private var recipesFromDataBase: [Int: DetailedRecipeEntity]
    
    init(coreDataService: CoreDataServiceProtocol, userDefaultsService: UserDefaultsServiceProtocol) {
        self.coreDataService = coreDataService
        self.recipesFromDataBase = [:]
        self.userDefaultsService = userDefaultsService
    }
    
    /// Method that downloads cooked ever recipes form core data persistent storage using
    /// userDefaults service to get cooked recipes ids
    func getHistory() {
        let fetchedIds: Set<Int>? = self.userDefaultsService.getSet(key: self.userDefaultsService.historyKey)
        
        guard let currentIds = fetchedIds else {
            self.presenter?.noDataFetched()
            return
        }
        
        if fetchedIds?.count == 0 {
            self.presenter?.noDataFetched()
            return
        }
        
        self.coreDataService.loadRecipes(specificIds: currentIds, completion: { models in
            if models.count != 0 {
                self.recipesFromDataBase = models
                self.presenter?.takeHistory(Array(models.values))
            } else {
                self.presenter?.noDataFetched()
            }
        })
    }
    
    /// Method that gets specific recipe info and passes it to presenter
    ///
    /// - Parameter id: id of recipe that is needed
    func getDetailedRecipe(id: Int) {
        guard let recipeDetails = recipesFromDataBase[id] else {
            return
        }
        self.presenter?.takeRecipeInfo(recipeDetails)
    }
    
}
