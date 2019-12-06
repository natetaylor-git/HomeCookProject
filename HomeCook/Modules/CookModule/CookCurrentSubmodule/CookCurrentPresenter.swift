//
//  CookCurrentPresenter.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class CookCurrentPresenter: CookCurrentInteractorOutputProtocol {
    var interactor: CookCurrentInteractorInputProtocol?
    weak var view: CookCurrentPresenterOutputProtocol?
    
}

extension CookCurrentPresenter: CookCurrentPresenterInputProtocol {
    func viewLoaded() {
        
    }
    
}
