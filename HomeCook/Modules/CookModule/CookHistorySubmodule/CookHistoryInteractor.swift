//
//  CookHistoryInteractor.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class CookHistoryInteractor: CookHistoryInteractorInputProtocol {
    weak var presenter: CookHistoryInteractorOutputProtocol?
    let coreDataService: CoreDataServiceProtocol
    
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }
    
    func getHistory() {
        self.coreDataService.loadRecipes(completion: { models in
            if models.count != 0 {
                self.presenter?.takeHistory(models)
            }
        })
    }
    
}
