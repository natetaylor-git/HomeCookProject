//
//  RecipeDetailView.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 02/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class RecipeDetailView: UIView {
    let headerLabel = UILabel()
    let nameLabel = UILabel()
    let valueLabel = UILabel()
    let headerHeight: CGFloat = 15
    let betweenPadding: CGFloat = 10
    
    init(frame: CGRect, name: String, value: String) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setupHeaderLabel()
        setupNameLabel(name: name)
        setupValueLabel(value: value)
        
        self.addSubview(headerLabel)
        self.addSubview(nameLabel)
        self.addSubview(valueLabel)
        
        drawLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHeaderLabel() {
        self.headerLabel.frame = CGRect(origin: .zero,
                                        size:CGSize(width: self.frame.width, height: headerHeight))
        self.headerLabel.backgroundColor = UIColor.lightGreen
    }
    
    func setupNameLabel(name: String) {
        self.nameLabel.frame = CGRect(origin: CGPoint(x: 0, y: headerLabel.frame.maxY),
                                      size:CGSize(width: self.frame.width,
                                                  height: (self.frame.height - headerHeight - betweenPadding) / 2))
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        self.nameLabel.text = name
    }
    
    func setupValueLabel(value: String) {
        self.valueLabel.font = UIFont.systemFont(ofSize: 16.0)
        self.valueLabel.frame = CGRect(origin: CGPoint(x: 0, y: nameLabel.frame.maxY + betweenPadding),
                                       size: CGSize(width: self.frame.width,
                                                    height: self.nameLabel.frame.height))
        self.valueLabel.text = value
    }
    
    func drawLine() {
        let path = UIBezierPath()
        let levelY = self.nameLabel.frame.maxY + betweenPadding / 2
        path.move(to: CGPoint(x: 0, y: levelY))
        path.addLine(to: CGPoint(x: self.nameLabel.frame.maxX, y: levelY))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.lineWidth = 0.5
        self.layer.addSublayer(shapeLayer)
    }
}
