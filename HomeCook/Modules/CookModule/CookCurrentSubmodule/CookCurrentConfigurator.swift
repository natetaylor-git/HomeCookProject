//
//  CookConfigurator.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class CookCurrentConfigurator: CookCurrentConfiguratorProtocol {
    
    func configure(with viewController: CookCurrentViewController) {
        let presenter = CookCurrentPresenter()
        let localRecipesCollection = LocalRecipesCollection.shared
        let coreDataService = CoreDataService()
        let userDefaultsService = UserDefaultsService()
        let interactor = CookCurrentInteractor(localCollection: localRecipesCollection,
                                               coreDataService: coreDataService,
                                               userDefaultsService: userDefaultsService)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewController
    }
}
