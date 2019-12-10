//
//  MainInteractor.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class MainInteractor: MainInteractorInputProtocol {
    weak var presenter: MainInteractorOutputProtocol?
    let coreDataService: CoreDataServiceProtocol
    let userDefaultsService: UserDefaultsServiceProtocol
    var localRecipesCollection: LocalRecipesCollectionProtocol
    
    init(coreDataService: CoreDataServiceProtocol,
         userDefaultsService: UserDefaultsServiceProtocol,
         localRecipesCollection: LocalRecipesCollectionProtocol) {
        
        self.coreDataService = coreDataService
        self.userDefaultsService = userDefaultsService
        self.localRecipesCollection = localRecipesCollection
        
//        self.userDefaultsService.setHintStatusToNeeded()
//        self.coreDataService.deleteAllRecipes(completion: {lol in })
//        self.userDefaultsService.clearAllCustomKeys()
        
    }
    
    func loadCurrentRecipes() {
        let fetchedIds: Set<Int>? = self.userDefaultsService.getSet()
        guard let currentIds = fetchedIds else {
            return
        }
        
        if fetchedIds?.count == 0 {
            return
        }
        
        self.coreDataService.loadRecipes(specificIds: currentIds, completion: { models in
            self.localRecipesCollection.localRecipes.dict = models
            let ingredientsCollection = IngredientsCollection.shared
            let summary = ingredientsCollection.getCurrentIngredientsSummary(localRecipesCollection: self.localRecipesCollection)
            ingredientsCollection.summary = summary
        })
        
//        UserDefaults.standard.removeObject(forKey: userDefaultsService.boughtIngredientsKey)
//        self.userDefaultsService.setHintStatusToNeeded()
    }
}
