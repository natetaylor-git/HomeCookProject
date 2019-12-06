//
//  BuyPresenter.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class BuyPresenter: BuyInteractorOutputProtocol {
    var interactor: BuyInteractorInputProtocol?
    weak var view: BuyPresenterOutputProtocol?
    
}

extension BuyPresenter: BuyPresenterInputProtocol {
    func viewLoaded() {
        
    }
    
}
