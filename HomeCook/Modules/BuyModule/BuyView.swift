//
//  BuyView.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController {
    var presenter: BuyPresenterInputProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BuyViewController: BuyPresenterOutputProtocol {
    
}
