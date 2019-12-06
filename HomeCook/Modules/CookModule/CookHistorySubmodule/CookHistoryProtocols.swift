//
//  CookHistoryProtocols.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

protocol CookHistoryConfiguratorProtocol: class {
    func configure(with viewController: CookHistoryViewController)
}

protocol CookHistoryPresenterInputProtocol: class {
    func viewLoaded()
}

protocol CookHistoryPresenterOutputProtocol: class {
    func showHistory(_ cells: [(String, [RecipeCellModel])])
}

protocol CookHistoryInteractorInputProtocol: class {
    func getHistory()
}

protocol CookHistoryInteractorOutputProtocol: class {
    func takeHistory(_ models: [DetailedRecipeEntity])
}
