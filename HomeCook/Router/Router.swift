//
//  Router.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

/// Class that contains all navigation logic starting from main screen assigning existing
/// transitions to callbacks of specific screens
class Router: NSObject {
    var navigationController: UINavigationController?
    
    static let shared: Router = {
        let mainViewController = MainViewController()
        let configurator = MainConfigurator()
        configurator.configure(with: mainViewController)
        
        let navigationController = UINavigationController(rootViewController: mainViewController)
        let router = Router(navigationController: navigationController)
        return router
    }()
    
    private init(navigationController: UINavigationController) {
        super.init()
        self.navigationController = navigationController
        self.navigationController?.delegate = self
        setupMainScreen()
    }
    
    /// Method that concretizes transitions from main screen buttons
    private func setupMainScreen() {
        guard let root = self.navigationController?.viewControllers.first as? MainViewController else {
            return
        }
        
        root.clickedOnSearchButton = {[weak self] in
            self?.showSearchScreen()
        }
        root.clickedOnBuyButton = {[weak self] in
            self?.showBuyScreen()
        }
        root.clickedOnCookButton = {[weak self] in
            self?.showCookScreen()
        }
    }
    
    /// Method that creates configured instance of search screen and concretizes its transition
    private func showSearchScreen() {
        let searchViewController = SearchViewController()
        let configurator = SearchConfigurator()
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        configurator.configure(with: searchViewController)
        searchViewController.clickedOnCell = { [weak self] recipeEntity in
            self?.showRecipeDetailsScreen(recipeInfo: recipeEntity)
        }
        
        searchViewController.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    /// Method that creates configured instance of details screen and concretizes its transition
    private func showRecipeDetailsScreen(recipeInfo: DetailedRecipeEntity) {
        let recipeDetailsController = RecipeDetailsViewController()
        let configurator = RecipeDetailsConfigurator()
        configurator.configure(with: recipeDetailsController, recipeEntity: recipeInfo)
        recipeDetailsController.navigationItem.title = "Recipe Details"
        self.navigationController?.pushViewController(recipeDetailsController, animated: true)
    }
    
    /// Method that creates configured instance of buy screen and concretizes its transition
    private func showBuyScreen() {
        let buyViewController = BuyViewController()
        let configurator = BuyConfigurator()
        configurator.configure(with: buyViewController)
        buyViewController.navigationItem.title = "Shopping List"
        self.navigationController?.pushViewController(buyViewController, animated: true)
    }
    
    /// Method that creates configured instance of tab bar screen with two imbeded cook screens and
    /// concretizes transitions
    private func showCookScreen() {
        let currentController = CookCurrentViewController()
        let currentConfigurator = CookCurrentConfigurator()
        currentConfigurator.configure(with: currentController)
        
        let historyController = CookHistoryViewController()
        let historyConfigurator = CookHistoryConfigurator()
        historyConfigurator.configure(with: historyController)
        historyController.clickedOnCell = { [weak self] recipeEntity in
            self?.showRecipeDetailsScreen(recipeInfo: recipeEntity)
        }

        let item1 = UITabBarItem(title: "Current", image: nil, tag: 1)
        let item2 = UITabBarItem(title: "History", image: nil, tag: 2)

        currentController.tabBarItem = item1
        historyController.tabBarItem = item2

        let cookTabBarController = UITabBarController()
        cookTabBarController.viewControllers = [currentController, historyController]
        cookTabBarController.navigationItem.title = "Cook"
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        cookTabBarController.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(cookTabBarController, animated: true)
    }
}

extension Router: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

// MARK: - Extension for assigning custom navigation animations to navigation controller
extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .pop:
            guard toVC is MainViewController else {
                return nil
            }
            return PopAnimator()
        case .push:
            guard fromVC is MainViewController else {
                return nil
            }
            return PushAnimator()
        default: return nil
        }
    }
}
