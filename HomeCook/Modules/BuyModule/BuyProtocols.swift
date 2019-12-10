//
//  BuyProtocols.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

protocol BuyConfiguratorProtocol: class {
    func configure(with viewController: BuyViewController)
}

protocol BuyPresenterInputProtocol: class {
    func viewLoaded()
    func alertWasShown()
    func viewWillDisappear(bought: [IngredientBuyModel])
}

protocol BuyPresenterOutputProtocol: class {
    func showHint()
    func setIngredients(active: [IngredientBuyModel], bought: [IngredientBuyModel])
}

protocol BuyInteractorInputProtocol: class {
    func checkIfHintIsNeeded()
    func turnHintOff()
    func getIngredientsSummary()
    func saveBoughtIngredients(ingredients: Set<String>)
}

protocol BuyInteractorOutputProtocol: class {
    func hintNeeded()
    func takeIngredients(summarized: [String: IngredientBuyModel], boughtLabels: Set<String>)
}
