//
//  CookHistoryViewController.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class CookHistoryViewController: UIViewController {
    var configurator: CookHistoryConfiguratorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurator = CookHistoryConfigurator()
        configurator?.configure(with: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

}
