//
//  CookTabBarController.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class CookTabBarController: UITabBarController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let currentController = CookCurrentViewController()
        let historyController = CookHistoryViewController()
        
        let item1 = UITabBarItem(title: "Current", image: nil, tag: 1)
        let item2 = UITabBarItem(title: "History", image: nil, tag: 2)
        
        currentController.tabBarItem = item1
        historyController.tabBarItem = item2
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.viewControllers = [currentController, historyController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
