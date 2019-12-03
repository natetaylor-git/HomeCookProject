//
//  ViewController.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var configurator: MainConfiguratorProtocol?

    let searchButton: UIButton = {
        let button = UIButton()
//        button.setImage(UIImage(named: "SearchIcon"), for: .normal)
        button.backgroundColor = .lightGray
        button.setTitle("Search", for: .normal)
        button.addTarget(self, action: #selector(tappedSearchButton), for: .touchUpInside)
        return button
    }()
    
    let buyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("Buy", for: .normal)
        return button
    }()
    
    let cookButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "CookIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .lightGray
        button.setTitle("Cook", for: .normal)
        button.addTarget(self, action: #selector(tappedCookButton), for: .touchUpInside)
        return button
    }()
    
    var clickedOnSearchButton: (() -> Void)?
    var clickedOnBuyButton: (() -> Void)?
    var clickedOnCookButton: (() -> Void)?
    
    @objc func tappedSearchButton() {
        clickedOnSearchButton?()
    }
    
    @objc func tappedCookButton() {
        clickedOnCookButton?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurator = MainConfigurator()
        configurator?.configure(with: self)
        
        setupUI()
    }
    
    func setupUI() {
        self.navigationItem.title = "Main"
        layoutButtons()
    }
    
    private func layoutButtons() {
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        
        let buttons = [self.searchButton, self.buyButton, self.cookButton]
        let numButtons = buttons.count
        
        let freeArea = safeFrame.height
        let paddingOfButtonsAreaRatio: CGFloat = 0.4
        let paddingOfButtonsArea = paddingOfButtonsAreaRatio * freeArea / 2
        let buttonsArea =  freeArea * (1 - paddingOfButtonsAreaRatio)
        
        let paddingOfButtonRatio: CGFloat = 0.5
        let buttonHeight = buttonsArea / (CGFloat(numButtons) + CGFloat(numButtons - 1) * paddingOfButtonRatio)
        let buttonSize = CGSize(width: safeFrame.width, height: buttonHeight)
        let paddingBetweenButtons: CGFloat = buttonSize.height * paddingOfButtonRatio
        
        for (index, button) in buttons.enumerated() {
            let buttonOriginY = safeFrame.origin.y + paddingOfButtonsArea +
                CGFloat(index) * (buttonSize.height + paddingBetweenButtons)
            let buttonOrigin = CGPoint(x: safeFrame.origin.x, y: buttonOriginY)
            button.frame = CGRect(origin: buttonOrigin, size: buttonSize)
            
            self.view.addSubview(button)
        }
    }
}

