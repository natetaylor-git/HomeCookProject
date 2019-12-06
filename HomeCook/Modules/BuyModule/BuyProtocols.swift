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
}

protocol BuyPresenterOutputProtocol: class {
}

protocol BuyInteractorInputProtocol: class {
}

protocol BuyInteractorOutputProtocol: class {
}
