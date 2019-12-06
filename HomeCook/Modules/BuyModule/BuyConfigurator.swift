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
        let interactor = BuyInteractor()
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewController
    }
}
