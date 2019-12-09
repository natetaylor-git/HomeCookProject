//
//  BuyPresenter.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class BuyPresenter: BuyPresenterInputProtocol {
    var interactor: BuyInteractorInputProtocol?
    weak var view: BuyPresenterOutputProtocol?
 
    
    func viewLoaded() {
//        self.interactor.getIngredientsSummary()
    }
    
}

extension BuyPresenter: BuyInteractorOutputProtocol {

}
