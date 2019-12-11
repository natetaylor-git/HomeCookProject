//
//  BuyPresenter.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class BuyPresenter: BuyPresenterInputProtocol {
    var interactor: BuyInteractorInputProtocol?
    weak var view: BuyPresenterOutputProtocol?
 
    func viewLoaded() {
        self.interactor?.checkIfHintIsNeeded()
        self.interactor?.getIngredientsSummary()
    }
    
    func alertWasShown() {
        self.interactor?.turnHintOff()
    }
    
    func viewWillDisappear(bought: [IngredientBuyModel]) {
        let boughtIngredientsSet = Set<String>(bought.map{$0.name})
        self.interactor?.saveBoughtIngredients(ingredients: boughtIngredientsSet)
    }
}

extension BuyPresenter: BuyInteractorOutputProtocol {
    func hintNeeded() {
        self.view?.showHint()
    }
    
    /// Method that passes ingredients summary to view and names of bought ingredients
    ///
    /// - Parameters:
    ///   - summarized: ingredients summary
    ///   - boughtLabels: names of bought ingredients
    func takeIngredients(summarized: [String: IngredientBuyModel], boughtLabels: Set<String>) {
        var activeIngredients = [IngredientBuyModel]()
        var boughtIngredients = [IngredientBuyModel]()
        
        for ingredient in summarized {
            if boughtLabels.contains(ingredient.key) {
                boughtIngredients.append(ingredient.value)
            } else {
                activeIngredients.append(ingredient.value)
            }
        }
        
        self.view?.setIngredients(active: activeIngredients, bought: boughtIngredients)
    }
}
