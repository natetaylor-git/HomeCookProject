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
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let buyButton: ImageButton = {
        let button = ImageButton(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)), imageName: "BuyIconDetailed", brightColor: .blue, shadow: true)
        return button
    }()
    
    var infoDetailsViews = [RecipeDetailView]()
    
    let paddingX: CGFloat = 5
    let paddingY: CGFloat = 10
    let labelHeight: CGFloat = 100
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
    
//    func findFitAspectInRect(_ rect: CGRect, actualSize: CGSize) -> CGRect {
//        let scale: CGFloat
//        if actualSize.width >= actualSize.height {
//            scale = rect.width / actualSize.width
//        } else {
//            scale = rect.height / actualSize.height
//        }
//
//        let size = CGSize(width: actualSize.width * scale, height: actualSize.height * scale)
//        let x = (rect.width - size.width) / 2.0
//        let y = (rect.height - size.height) / 2.0
//
//        return CGRect(x: x, y: y, width: size.width, height: size.height)
//    }
}

extension RecipeDetailsViewController: UIScrollViewDelegate {

}

extension RecipeDetailsViewController: RecipeDetailsPresenterOutputProtocol {
    func setupImageView(with image: UIImage) {
        self.imageView.image = image
        let scrollViewBounds = self.scrollView.bounds
        let origin = CGPoint(x: paddingX, y: scrollViewBounds.origin.y)
        let size = CGSize(width: scrollViewBounds.width - 2 * paddingX,
                          height: scrollViewBounds.height / 2)
        self.imageView.frame = CGRect(origin: origin, size: size)
        
        let newFrame = self.imageView.findFitAspectInRect(self.imageView.frame)
        let newOrigin = CGPoint(x: paddingX + newFrame.minX, y: scrollViewBounds.origin.y)
        self.imageView.frame = CGRect(origin: newOrigin, size: newFrame.size)
        
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.backgroundColor = .blue
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width,
                                             height: self.scrollView.contentSize.height + self.imageView.frame.height)
        self.scrollView.addSubview(self.imageView)
    }
    
    func setupDetailsViews(with infoDetails: [(name: String, value: String)]) {
//        let imageViewFrame = self.imageView.frame
//        let labelWidth = imageViewFrame.width
//
//        var lastLabelMaxY = imageViewFrame.maxY
        let labelWidth = self.scrollView.bounds.width - 2 * paddingX
        
        var lastLabelMaxY = self.imageView.frame.maxY
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
            let origin = CGPoint(x: 0, y: lastIngredientMaxY)
            let size = CGSize(width: self.scrollView.frame.width - 2 * paddingX, height: 10)
            let ingredientView = IngredientView(frame: .zero)
            let stringAmount = String(ingredient.amount)
            ingredientView.setup(frame: CGRect(origin: origin, size: size),
                                 name: ingredient.name,
                                 amount: stringAmount,
                                 unit: ingredient.unit)
            ingredientView.changeLayout()
            
            let lineWidth: CGFloat = 1
            let start = CGPoint(x: self.paddingX, y: ingredientView.bounds.minY + lineWidth)
            let end = CGPoint(x: self.scrollView.frame.width - self.paddingX, y: start.y)
            drawDashedLine(view: ingredientView, color: .darkGreen, width: 1, start: start, end: end)
            
            lastIngredientMaxY = ingredientView.frame.maxY
            self.scrollView.addSubview(ingredientView)
        }
        
        if let header = self.infoDetailsViews.last {
            let ratio = IngredientView.ratio
            let frame = header.valueLabel.frame
            let newValueLabel = UILabel(frame: frame)
            
            let leftLabel = UILabel()
            let leftWidth = ratio * newValueLabel.frame.width
            let leftSize = CGSize(width: leftWidth, height: newValueLabel.frame.height)
            leftLabel.frame = CGRect(origin: .zero, size: leftSize)
            leftLabel.text = "Name:"
            leftLabel.textColor = .darkGray
            
            let rightLabel = UILabel()
            let rightOrigin = CGPoint(x: leftLabel.frame.maxX, y: 0)
            let rightSize = CGSize(width: newValueLabel.frame.width - leftWidth,
                                   height: leftSize.height)
            rightLabel.frame = CGRect(origin: rightOrigin, size: rightSize)
            rightLabel.text = "Amount:"
            rightLabel.textAlignment = .left
            rightLabel.textColor = .darkGray
            
            newValueLabel.addSubview(leftLabel)
            newValueLabel.addSubview(rightLabel)
            header.valueLabel.removeFromSuperview()
            header.addSubview(newValueLabel)
        }
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width,
                                             height: lastIngredientMaxY)
    }
    
    func drawDashedLine(view: UIView, color: UIColor, width: CGFloat, start: CGPoint, end: CGPoint) {
        let lineShapeLayer = CAShapeLayer()
        lineShapeLayer.strokeColor = UIColor.lightGray.cgColor
        lineShapeLayer.lineWidth = 1
        lineShapeLayer.lineDashPattern = [3, 3]
        
        let path = CGMutablePath()
        path.addLines(between: [start, end])
        lineShapeLayer.path = path
        view.layer.addSublayer(lineShapeLayer)
    }
    
    func activateUIElementsForEntityExistance() {
        self.buyButtonActive = true
        self.buyButton.changeImageColor()
    }
}


