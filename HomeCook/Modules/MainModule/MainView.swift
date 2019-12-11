//
//  ViewController.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var presenter: MainPresenterInputProtocol?
    var clickedOnSearchButton: (() -> Void)?
    var clickedOnBuyButton: (() -> Void)?
    var clickedOnCookButton: (() -> Void)?
    
    let searchButton = MainButtonView(frame: .zero,
                                      name: "Search",
                                      image: UIImage(named: "SearchIcon"))
    let buyButton = MainButtonView(frame: .zero,
                                   name: "Buy",
                                   image: UIImage(named: "BuyIcon"))
    let cookButton = MainButtonView(frame: .zero,
                                    name: "Cook",
                                    image: UIImage(named: "CookIcon"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter?.viewLoaded()
        
        setupUI()
        
        searchButton.addTarget(self, action: #selector(tappedSearchButton), for: .touchUpInside)
        buyButton.addTarget(self, action: #selector(tappedBuyButton), for: .touchUpInside)
        cookButton.addTarget(self, action: #selector(tappedCookButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupUI() {
        self.navigationItem.title = "Main"
        self.view.backgroundColor = .darkGreen
        
        layoutButtons()
        layoutBackgroundImage()
    }
    
    func layoutButtons() {
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        
        let buttons = [self.searchButton, self.buyButton, self.cookButton]
        let numButtons = buttons.count
        
        let paddingX: CGFloat = self.view.bounds.width / 5
        let freeArea = safeFrame.height
        let paddingOfButtonsAreaRatio: CGFloat = 0.3
        let paddingOfButtonsArea = paddingOfButtonsAreaRatio * freeArea / 2
        let buttonsArea =  freeArea * (1 - paddingOfButtonsAreaRatio)
        
        let paddingOfButtonRatio: CGFloat = 0.5
        let buttonHeight = buttonsArea / (CGFloat(numButtons) + CGFloat(numButtons - 1) * paddingOfButtonRatio)
        let buttonSize = CGSize(width: safeFrame.width - paddingX, height: buttonHeight)
        let paddingBetweenButtons: CGFloat = buttonSize.height * paddingOfButtonRatio
        
        for (index, button) in buttons.enumerated() {
            let buttonOriginY = safeFrame.origin.y + paddingOfButtonsArea +
                CGFloat(index) * (buttonSize.height + paddingBetweenButtons)
            let buttonOrigin = CGPoint(x: safeFrame.origin.x + paddingX, y: buttonOriginY)
            button.frame = CGRect(origin: buttonOrigin, size: buttonSize)
            
            self.view.addSubview(button)
        }
    }
    
    func layoutBackgroundImage() {
        guard let image = UIImage(named: "MainBackground") else {
            return
        }

        self.view.contentMode = .topLeft
        self.view.layer.contents = image.cgImage
    }
    
    @objc func tappedSearchButton() {
        clickedOnSearchButton?()
    }
    
    @objc func tappedCookButton() {
        clickedOnCookButton?()
    }
    
    @objc func tappedBuyButton() {
        clickedOnBuyButton?()
    }
}

extension MainViewController: MainPresenterOutputProtocol {
}
