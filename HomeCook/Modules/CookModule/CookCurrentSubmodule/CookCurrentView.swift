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
        
        let button = UIButton(frame: CGRect(x: 0, y: 200, width: 200, height: 200))
        button.setTitle("ola", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func tap() {
        
    }
}

extension CookCurrentViewController: CookCurrentPresenterOutputProtocol {
    
}
