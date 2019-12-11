//
//  MainProtocols.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol MainConfiguratorProtocol: class {
    func configure(with viewController: MainViewController)
}

protocol MainPresenterInputProtocol: class {
    func viewLoaded()
}

protocol MainPresenterOutputProtocol: class {
}

protocol MainInteractorInputProtocol: class {
    func loadCurrentRecipes()
}

protocol MainInteractorOutputProtocol: class {
}
