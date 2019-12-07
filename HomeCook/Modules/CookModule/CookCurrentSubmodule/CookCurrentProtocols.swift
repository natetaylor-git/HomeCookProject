//
//  CookCurrentProtocols.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol CookCurrentConfiguratorProtocol: class {
    func configure(with viewController: CookCurrentViewController)
}

protocol CookCurrentPresenterInputProtocol: class {
    func viewLoaded()
    func viewWillAppear()
}

protocol CookCurrentPresenterOutputProtocol: class {
    func updateCollectionView(with recipes: [(name: String, image: UIImage, instructions: String)])
}

protocol CookCurrentInteractorInputProtocol: class {
    func getCurrentRecipes()
    func checkIfLocalRecipesUpdated()
}

protocol CookCurrentInteractorOutputProtocol: class {
    func takeCurrentRecipes(_ recipes: LocalRecipesCollectionProtocol)
}
