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
