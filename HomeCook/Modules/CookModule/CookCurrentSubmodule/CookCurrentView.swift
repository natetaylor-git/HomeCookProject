//
//  CookViewController.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class CookCurrentViewController: UIViewController {
    var presenter: CookCurrentPresenterInputProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CookCurrentViewController: CookCurrentPresenterOutputProtocol {
    
}
