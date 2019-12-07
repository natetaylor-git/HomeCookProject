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
        let interactor = CookCurrentInteractor(localRecipesCollection: LocalRecipesCollection.shared)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewController
    }
}
