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
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let buyButton: ImageButton = {
        let button = ImageButton(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)), imageName: "BuyIconDetailed", brightColor: .blue, shadow: true)
        return button
    }()
    
    var infoDetailsViews = [RecipeDetailView]()
    
    let paddingX: CGFloat = 5
    var buyButtonActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialUI()
        self.presenter?.viewLoaded()
        self.scrollView.delegate = self
        
        self.view.addSubview(scrollView)
    }
    
    func setupInitialUI() {
        setupBuyButton()
        setupScrollView()
    }
    
    func setupBuyButton() {
        self.buyButton.addTarget(self, action: #selector(tappedBuyButton), for: .touchUpInside)
        let item = UIBarButtonItem(customView: self.buyButton)
        self.navigationItem.rightBarButtonItem = item
    }
    
    @objc func tappedBuyButton() {
        self.buyButtonActive = !self.buyButtonActive
        self.buyButton.changeImageColor()
        if self.buyButtonActive {
            self.presenter?.buyButtonActive()
        } else {
            self.presenter?.buyButtonNotActive()
        }
    }
    
    func setupScrollView() {
        self.scrollView.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                                       size: CGSize(width: self.view.frame.width,
                                                    height: self.view.frame.maxY))
    }
}

extension RecipeDetailsViewController: UIScrollViewDelegate {

}

extension RecipeDetailsViewController: RecipeDetailsPresenterOutputProtocol {
    func setupImageView(with image: UIImage) {
        let scrollViewBounds = self.scrollView.bounds
        let origin = CGPoint(x: paddingX, y: scrollViewBounds.origin.y)
        let size = CGSize(width: scrollViewBounds.width - 2 * paddingX,
                          height: scrollViewBounds.height / 2)
        self.imageView.frame = CGRect(origin: origin, size: size)
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.backgroundColor = .blue
        self.imageView.image = image
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width,
                                             height: self.scrollView.contentSize.height + self.imageView.frame.height)
        self.scrollView.addSubview(self.imageView)
    }
    
    func setupDetailsViews(with infoDetails: [(name: String, value: String)]) {
        let paddingY: CGFloat = 10
        let imageViewFrame = self.imageView.frame
        let labelWidth = imageViewFrame.width
        let labelHeight: CGFloat = 100
        
        var lastLabelMaxY = imageViewFrame.maxY
        for detail in infoDetails {
            let origin = CGPoint(x: self.paddingX, y: lastLabelMaxY + paddingY)
            let size = CGSize(width: labelWidth, height: labelHeight)
            let frame = CGRect(origin: origin, size: size)
            
            let detailView = RecipeDetailView(frame: frame, name: detail.name, value: detail.value)
            detailView.backgroundColor = .white
            
            lastLabelMaxY = detailView.frame.maxY
            
            self.infoDetailsViews.append(detailView)
            self.scrollView.addSubview(detailView)
        }
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width,
                                             height: lastLabelMaxY)
    }
    
    func setupIngredientsView(with info: [IngredientModel]) {
        let baseHeight = self.infoDetailsViews.last?.frame.maxY ?? 0
        var lastIngredientMaxY: CGFloat = baseHeight
        for ingredient in info {
            let origin = CGPoint(x: self.paddingX, y: lastIngredientMaxY)
            let size = CGSize(width: self.imageView.frame.width, height: 10)
            let ingredientView = IngredientView(frame: .zero)
            let stringAmount = String(ingredient.amount)
            ingredientView.setup(frame: CGRect(origin: origin, size: size),
                                 name: ingredient.name,
                                 amount: stringAmount,
                                 unit: ingredient.unit)
            ingredientView.changeLayout()
            lastIngredientMaxY = ingredientView.frame.maxY
            self.scrollView.addSubview(ingredientView)
        }
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width,
                                             height: lastIngredientMaxY)
    }
    
    func activateUIElementsForEntityExistance() {
        self.buyButtonActive = true
        self.buyButton.changeImageColor()
    }
}


