//
//  RecipeDetailedView.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    var presenter: RecipeDetailsPresenterInputProtocol?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    let buyButton: ImageButton = {
        let button = ImageButton(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)),
                              imageName: "BuyIcon")
        return button
    }()
    
    let paddingX: CGFloat = 10
    var buyButtonActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter?.viewLoaded()
        self.scrollView.delegate = self
        
        setupUI()
        
        self.view.addSubview(scrollView)
    }
    
    func setupUI() {
        setupBuyButton()
        setupScrollView()
    }
    
    func setupBuyButton() {
        self.buyButton.addTarget(self, action: #selector(tappedBuyButton), for: .touchUpInside)
        let item = UIBarButtonItem(customView: self.buyButton)
        self.navigationItem.rightBarButtonItem = item
    }
    
    @objc func tappedBuyButton() {
        self.buyButton.changeImageColor()
    }
    
    func setupScrollView() {
        self.scrollView.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                                       size: CGSize(width: self.view.frame.width,
                                                    height: self.view.frame.maxY))
        setupImageView()
        setupLabels()
        self.scrollView.backgroundColor = .white// UIColor.init(red: 152/255, green: 251/255, blue: 152/255, alpha: 1.0)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width,
                                             height: self.imageView.frame.height * 5)
        self.scrollView.addSubview(self.imageView)
    }
    
    func setupImageView() {
        let scrollViewBounds = self.scrollView.bounds
        let origin = CGPoint(x: paddingX, y: scrollViewBounds.origin.y)
        let size = CGSize(width: scrollViewBounds.width - 2 * paddingX,
                          height: scrollViewBounds.height / 2)
        self.imageView.frame = CGRect(origin: origin, size: size)
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.backgroundColor = .blue
    }
    
    func setupLabels() {
        let paddingY: CGFloat = 10
        let imageViewFrame = self.imageView.frame
        let origin = CGPoint(x: paddingX, y: imageViewFrame.maxY + paddingY)
        let size = CGSize(width: imageViewFrame.width, height: 100)
        let cousineFrame = CGRect(origin: origin, size: size)
        let cousineView = RecipeDetailView(frame: cousineFrame, name: "Кухня", value: "Русская")
        cousineView.backgroundColor = .white
        self.scrollView.addSubview(cousineView)
        cousineView.setNeedsDisplay()
        
        let origin2 = CGPoint(x: paddingX, y: cousineFrame.maxY + paddingY)
        let size2 = CGSize(width: imageViewFrame.width, height: 100)
        let cousineFrame2 = CGRect(origin: origin2, size: size2)
        let cousineView2 = RecipeDetailView(frame: cousineFrame2, name: "Тип блюда", value: "Завтрак")
        cousineView2.backgroundColor = .white
        self.scrollView.addSubview(cousineView2)
    }
}

extension RecipeDetailsViewController: UIScrollViewDelegate {

}

extension RecipeDetailsViewController: RecipeDetailsPresenterOutputProtocol {
    func updateImageView(with image: UIImage) {
        self.imageView.image = image
    }
}


