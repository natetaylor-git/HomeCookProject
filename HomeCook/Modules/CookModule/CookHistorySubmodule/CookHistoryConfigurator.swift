//
//  CookHistoryConfigurator.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class CookHistoryConfigurator: CookHistoryConfiguratorProtocol {
    
    func configure(with viewController: CookHistoryViewController) {
        let presenter = CookHistoryPresenter()
        let coreDataService = CoreDataService()
        let interactor = CookHistoryInteractor(coreDataService: coreDataService)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewController
    }
}
