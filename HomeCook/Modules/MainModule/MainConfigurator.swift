//
//  MainConfigurator.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class MainConfigurator: MainConfiguratorProtocol {
    func configure(with viewController: MainViewController) {
        let presenter = MainPresenter()
        let coreDataService = CoreDataService()
        let userDefaultsService = UserDefaultsService()
        let localRecipesCollection = LocalRecipesCollection.shared
        let interactor = MainInteractor(coreDataService: coreDataService,
                                        userDefaultsService: userDefaultsService,
                                        localRecipesCollection: localRecipesCollection)

        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewController
    }
}
