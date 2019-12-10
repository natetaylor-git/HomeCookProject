//
//  IngredientView.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 09/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class IngredientView: UIView {
    let nameLabel = UILabel(frame: .zero)
    let amountLabel = UILabel(frame: .zero)
    let unitLabel = UILabel(frame: .zero)
    let padding: CGFloat = 5
    let nameFontSize: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.nameLabel.numberOfLines = 0
        self.nameLabel.lineBreakMode = .byWordWrapping
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: self.nameFontSize)
        self.amountLabel.textAlignment = .left
        self.unitLabel.textAlignment = .right
        self.amountLabel.textColor = .darkGray
        self.unitLabel.textColor = .darkGray
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
    
    override func layoutSubviews() {
        let selfWidth = self.bounds.width
        let selfHeight = self.bounds.height
        
        let desiredSize = CGSize(width: selfWidth, height: CGFloat.greatestFiniteMagnitude)
        let nameFittedSize = self.nameLabel.sizeThatFits(desiredSize)
        self.nameLabel.frame = CGRect(origin: .zero,
                                      size: CGSize(width: selfWidth, height: nameFittedSize.height))
        
        let amountHeight = selfHeight - self.nameLabel.frame.height - padding
        let amountFittedSize = self.amountLabel.sizeThatFits(CGSize(width: selfWidth,
                                                                    height: amountHeight))
        let amountOrigin = CGPoint(x: 0, y: self.nameLabel.frame.maxY + padding)
        let amountSize = CGSize(width: amountFittedSize.width, height: amountHeight)
        self.amountLabel.frame = CGRect(origin: amountOrigin, size: amountSize)
        
        let unitOrigin = CGPoint(x: self.amountLabel.frame.maxX, y: self.amountLabel.frame.minY)
        let unitSize = CGSize(width: selfWidth - self.amountLabel.frame.width,
                              height: self.amountLabel.frame.height)
        self.unitLabel.frame = CGRect(origin: unitOrigin, size: unitSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
