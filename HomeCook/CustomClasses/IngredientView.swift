//
//  IngredientView.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 09/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

/// Class for specific ingredient view (consists of name, amount and unit labels)
class IngredientView: UIView {
    let nameLabel = UILabel(frame: .zero)
    let amountLabel = UILabel(frame: .zero)
    let unitLabel = UILabel(frame: .zero)

    let nameFontSize: CGFloat = 20
    let amountWidth: CGFloat
    let maxAmount = String(9999)
    let amountAndUnitFont = UIFont.systemFont(ofSize: 14)
    let paddingX: CGFloat = 5
    let paddingY: CGFloat = 5
    let paddingBetweenX: CGFloat = 0
    let paddingBetweenY: CGFloat = 0
    static let ratio: CGFloat = 4/7
    
    override init(frame: CGRect) {
        let amountWidth = self.maxAmount.size(withAttributes: [NSAttributedString.Key.font: self.amountAndUnitFont])
        self.amountWidth = amountWidth.width
        
        super.init(frame: frame)
        
        self.nameLabel.numberOfLines = 0
        self.nameLabel.lineBreakMode = .byWordWrapping
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: self.nameFontSize)
        
        self.amountLabel.textColor = .blue
        self.amountLabel.textAlignment = .left
        
        self.unitLabel.textColor = .blue
        self.unitLabel.textAlignment = .left
        self.unitLabel.numberOfLines = 0
        self.unitLabel.lineBreakMode = .byWordWrapping
        self.autoresizingMask = [.flexibleHeight]
        
        self.addSubview(nameLabel)
        self.addSubview(amountLabel)
        self.addSubview(unitLabel)
    }
    
    func setup(frame: CGRect, name: String, amount: String, unit: String) {
        self.frame = frame
        self.nameLabel.text = name
        self.amountLabel.text = amount
        self.unitLabel.text = unit
    }
    
    func changeLayout() {
        let contentWidth = self.bounds.width - paddingX
        let nameWidth = contentWidth * IngredientView.ratio
        let featureWidth = contentWidth - nameWidth - paddingBetweenX
        
        let amountOrigin = CGPoint(x: self.bounds.width - featureWidth + paddingX, y: paddingY)
        let amounDesiredSize = CGSize(width: featureWidth, height: CGFloat.greatestFiniteMagnitude)
        let amountFittedSize = self.amountLabel.sizeThatFits(amounDesiredSize)
        let amountSize = CGSize(width: featureWidth, height: amountFittedSize.height)
        self.amountLabel.frame = CGRect(origin: amountOrigin, size: amountSize)
        
        let unitOrigin = CGPoint(x: self.amountLabel.frame.origin.x,
                                 y: self.amountLabel.frame.maxY + paddingBetweenY)
        let desiredUnitSize = CGSize(width: featureWidth, height: CGFloat.greatestFiniteMagnitude)
        let unitFittedSize = self.unitLabel.sizeThatFits(desiredUnitSize)
        let unitSize = CGSize(width: featureWidth, height: unitFittedSize.height)
        self.unitLabel.frame = CGRect(origin: unitOrigin, size: unitSize)
        
        let nameDesiredSize = CGSize(width: nameWidth, height: CGFloat.greatestFiniteMagnitude)
        let nameFittedSize = self.nameLabel.sizeThatFits(nameDesiredSize)
        let nameSize = CGSize(width: nameWidth, height: nameFittedSize.height)
        var nameOrigin: CGPoint = CGPoint(x: paddingX, y: paddingY)
        
        let featuresTotalHeight = self.amountLabel.frame.height + paddingBetweenY + self.unitLabel.frame.height
        let heightDifference = featuresTotalHeight - nameSize.height
        
        if heightDifference > 0 {
            nameOrigin = CGPoint(x: paddingX, y: paddingY + heightDifference / 2)
        } else {
            amountLabel.frame.origin = CGPoint(x: self.amountLabel.frame.origin.x,
                                               y: abs(heightDifference) / 2)
            unitLabel.frame.origin = CGPoint(x: self.unitLabel.frame.origin.x,
                                             y: self.amountLabel.frame.maxY + paddingBetweenY)
        }
        self.nameLabel.frame = CGRect(origin: nameOrigin, size: nameSize)
        
        let newHeight = 2 * paddingY + (heightDifference > 0 ? featuresTotalHeight : nameFittedSize.height)
        self.frame.size = CGSize(width: self.frame.width, height: newHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
