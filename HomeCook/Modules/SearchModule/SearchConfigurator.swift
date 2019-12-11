//
//  SearchConfigurator.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class SearchConfigurator: SearchConfiguratorProtocol {
    func configure(with viewController: SearchViewController) {
        let presenter = SearchPresenter()
        let networkService = NetworkService(session: SessionFactory().createDefaultSession())
        let interactor = SearchInteractor(networkService: networkService,
                                          filtersStorage: FilterParametersStorage.shared)

        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewController
    }
}
