//
//  Router.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class Router: NSObject {
    var navigationController: UINavigationController?
//    private var detailedRecipe: DetailedRecipeEntity?
    
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
    
    private func showRecipeDetailsScreen(recipeInfo: DetailedRecipeEntity) {
        let recipeDetailsController = RecipeDetailsViewController()
        let configurator = RecipeDetailsConfigurator()
        configurator.configure(with: recipeDetailsController, recipeEntity: recipeInfo)
        recipeDetailsController.navigationItem.title = "Recipe Details"
        self.navigationController?.pushViewController(recipeDetailsController, animated: true)
    }
    
    private func showBuyScreen() {
        let buyViewController = BuyViewController()
        let configurator = BuyConfigurator()
        configurator.configure(with: buyViewController)
        buyViewController.navigationItem.title = "Shop List"
        self.navigationController?.pushViewController(buyViewController, animated: true)
    }
    
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
        self.navigationController?.pushViewController(cookTabBarController, animated: true)
//        let historyController = CookHistoryViewController()
//        self.navigationController?.pushViewController(historyController, animated: true)
    }
    
    func push(viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        self.navigationController?.popViewController(animated: false)
    }
}

extension Router: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

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
