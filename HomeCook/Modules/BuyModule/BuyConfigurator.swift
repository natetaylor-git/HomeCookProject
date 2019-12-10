//
//  BuyConfigurator.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class BuyConfigurator: BuyConfiguratorProtocol {
    
    func configure(with viewController: BuyViewController) {
        let presenter = BuyPresenter()
        let userDefaultsService = UserDefaultsService()
        let localRecipesCollection = LocalRecipesCollection.shared
        let ingredientsCollection = IngredientsCollection.shared
        let interactor = BuyInteractor(userDefaultsService: userDefaultsService,
                                       localCollection: localRecipesCollection,
                                       ingredientsCollection: ingredientsCollection)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewController
    }
}
