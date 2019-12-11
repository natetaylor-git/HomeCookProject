//
//  MainButton.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 08/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

/// Class for buttons at main screen
class MainButtonView: UIButton {
    let imageViewBackgroundView = UIView()
    
    let myImageView = UIImageView(frame: .zero)
    let textLabel = UILabel(frame: .zero)
    
    let fontSize: CGFloat = 30
    let cornerRadius: CGFloat = 10.0
    
    init(frame: CGRect, name: String, image: UIImage?) {
        super.init(frame: frame)
        
        self.myImageView.image = image
        self.myImageView.contentMode = .scaleAspectFit
        self.myImageView.backgroundColor = .white
    
        self.imageViewBackgroundView.isUserInteractionEnabled = false
        self.imageViewBackgroundView.layer.cornerRadius = cornerRadius
        self.imageViewBackgroundView.backgroundColor = .white
        
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
        self.backgroundColor = .darkGreen
        
        self.imageViewBackgroundView.addSubview(myImageView)
        self.addSubview(imageViewBackgroundView)
        self.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let imagePadding: CGFloat = 5
        
        let side = self.frame.height
        let imageViewBackgroundSize = CGSize(width: side, height: side)
        self.imageViewBackgroundView.frame = CGRect(origin: .zero, size: imageViewBackgroundSize)
        
        let imageViewOrigin = CGPoint(x: imagePadding, y: imagePadding)
        let imageViewSize = CGSize(width: imageViewBackgroundSize.width - 2 * imagePadding,
                                   height: imageViewBackgroundSize.height - 2 * imagePadding)
        self.myImageView.frame = CGRect(origin: imageViewOrigin, size: imageViewSize)

        let labelOrigin = CGPoint(x: self.imageViewBackgroundView.frame.maxX, y: 0)
        let labelSize = CGSize(width: self.bounds.width - self.imageViewBackgroundView.frame.width,
                               height: self.bounds.height)
        self.textLabel.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
}
