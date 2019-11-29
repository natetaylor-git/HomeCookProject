//
//  Router.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class Router {
    var navigationController: UINavigationController?
    
    static let shared: Router = {
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        let router = Router(navigationController: navigationController)
        return router
    }()
    
    private init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        setupMainScreen()
    }
    
    private func setupMainScreen() {
        guard let root = self.navigationController?.viewControllers.first as? MainViewController else {
            return
        }
        
        root.clickedOnSearchButton = {[weak self] in
            self?.showSearchScreen()
        }
        root.clickedOnCookButton = {[weak self] in
            self?.showCookScreen()
        }
    }
    
    private func showSearchScreen() {
        let searchViewController = SearchViewController()
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    private func showCookScreen() {
        let currentController = CookCurrentViewController()
        let historyController = CookHistoryViewController()
        
        let item1 = UITabBarItem(title: "Current", image: nil, tag: 1)
        let item2 = UITabBarItem(title: "History", image: nil, tag: 2)
        
        currentController.tabBarItem = item1
        historyController.tabBarItem = item2
        
        let cookTabBarController = UITabBarController()
        cookTabBarController.viewControllers = [currentController, historyController]
        self.navigationController?.pushViewController(cookTabBarController, animated: true)
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
