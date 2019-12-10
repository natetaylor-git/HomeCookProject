//
//  MainButton.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 08/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class MainButtonView: UIButton {
    let myImageView = UIImageView(frame: .zero)
    let textLabel = UILabel(frame: .zero)
    
    let padding: CGFloat = 0
    let insetValue: CGFloat = 5
    let fontSize: CGFloat = 30
    let cornerRadius: CGFloat = 10.0
    
    init(frame: CGRect, name: String, image: UIImage?) {
        super.init(frame: frame)
        
        self.backgroundColor = .darkGreen
        self.myImageView.layer.cornerRadius = cornerRadius
        
        let insets = UIEdgeInsets(top: insetValue, left: insetValue,
                                  bottom: insetValue, right: insetValue)
        self.imageView?.contentMode = .center
        
        self.myImageView.image = image?.withAlignmentRectInsets(insets)
        self.myImageView.backgroundColor = .white
        
        self.textLabel.text = name
        self.textLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        self.textLabel.textColor = .white
        self.textLabel.backgroundColor = .darkGreen
        self.textLabel.textAlignment = .center

        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.cornerRadius = cornerRadius
        
        self.addSubview(myImageView)
        self.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let side = self.frame.height - 2 * padding
        let imageViewOrigin = CGPoint(x: padding, y: padding)
        let imageViewSize = CGSize(width: side, height: side)
        self.myImageView.frame = CGRect(origin: imageViewOrigin, size: imageViewSize)

        let labelOrigin = CGPoint(x: self.myImageView.frame.maxX, y: padding)
        let labelSize = CGSize(width: self.bounds.width - self.myImageView.frame.width,
                                height: self.bounds.height - 2 * padding)
        self.textLabel.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
}
