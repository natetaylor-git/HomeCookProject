//
//  MainPresenter.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class MainPresenter: MainPresenterInputProtocol {
    var interactor: MainInteractorInputProtocol?
    weak var view: MainPresenterOutputProtocol?
    
    func viewLoaded() {
        self.interactor?.loadCurrentRecipes()
    }
    
    func viewWillAppear() {
        
    }
}

extension MainPresenter: MainInteractorOutputProtocol {
    
}
