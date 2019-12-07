//
//  CookCurrentInteractor.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class CookCurrentInteractor: CookCurrentInteractorInputProtocol {
    weak var presenter: CookCurrentInteractorOutputProtocol?
    var localRecipesCollection: LocalRecipesCollectionProtocol
    private var existingLocalRecipesIds: Set<Int>
    private var needUpdate = false
    
    init(localRecipesCollection: LocalRecipesCollectionProtocol) {
        self.localRecipesCollection = localRecipesCollection
        self.existingLocalRecipesIds = Set<Int>(self.localRecipesCollection.localRecipes.dict.keys)
    }
    
    func getCurrentRecipes() {
        if self.localRecipesCollection.localRecipes.dict.count > 0 || needUpdate {
            self.presenter?.takeCurrentRecipes(localRecipesCollection)
        }
    }
    
    func checkIfLocalRecipesUpdated() {
//        var newRecipesExist = false
//        var setToCheckDeleted = Set<Int>(self.existingLocalRecipesIds)
//        for (key, _) in self.localRecipesCollection.localRecipes.dict {
//            setToCheckDeleted.remove(key)
//            if self.existingLocalRecipesIds.contains(key) == false {
//                newRecipesExist = true
//                self.existingLocalRecipesIds.insert(key)
//            }
//        }
//
//        self.needUpdate = newRecipesExist || setToCheckDeleted.count != 0
//        if self.needUpdate {
//             self.getCurrentRecipes()
//        }
        
        let currentRecipesIds = Set<Int>(self.localRecipesCollection.localRecipes.dict.keys)
        if self.existingLocalRecipesIds != currentRecipesIds {
            self.needUpdate = true
            self.existingLocalRecipesIds = currentRecipesIds
            self.getCurrentRecipes()
        } else {
            self.needUpdate = false
        }
    }
}
