//
//  HistoryCookCell.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class HistoryRecipeCell: UICollectionViewCell {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var recipeNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
//        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.font = UIFont.italicSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    override func prepareForReuse() {
        self.imageView.image = nil
        self.recipeNameLabel.text = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        
        let padding: CGFloat = 1
        let viewOrigin = self.bounds.origin
        let imageViewHeight = self.bounds.height * 5/6//* 3/4
        let recipeNameLabelHeight = self.bounds.height - padding - imageViewHeight

        let imageViewOrigin = CGPoint(x: 0,
                                      y: 0)
        self.imageView.frame = CGRect(origin: imageViewOrigin,
                                      size: CGSize(width: self.bounds.width, height: imageViewHeight))
        self.imageView.contentMode = .scaleAspectFill//.scaleAspectFit
        self.imageView.backgroundColor = .black
        self.imageView.layer.masksToBounds = true
        
//        self.imageView.layer.borderWidth = 1
//        self.imageView.layer.borderColor = UIColor.black.cgColor
        self.imageView.layer.cornerRadius = 10.0
        
        
//        let path = UIBezierPath(roundedRect:self.imageView.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 10, height: 10))
//        let maskLayer = CAShapeLayer()
//        maskLayer.borderColor = UIColor.black.cgColor
//        maskLayer.borderWidth = 1.0
//
//        maskLayer.path = path.cgPath
//        self.imageView.layer.mask = maskLayer
        
        
        
        self.contentView.addSubview(self.imageView)

        self.recipeNameLabel.frame = CGRect(origin: CGPoint(x: imageViewOrigin.x,
                                                            y: viewOrigin.y + imageViewHeight + padding),
                                            size: CGSize(width: imageView.frame.width,
                                                         height: recipeNameLabelHeight))
        self.recipeNameLabel.numberOfLines = 2
        self.recipeNameLabel.lineBreakMode = .byCharWrapping
        self.recipeNameLabel.layer.cornerRadius = 10.0
        self.recipeNameLabel.layer.masksToBounds = true
        
//        self.contentView.layer.borderWidth = 1.0
//        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.addSubview(self.recipeNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
