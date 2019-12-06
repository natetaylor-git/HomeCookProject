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
        label.textAlignment = .left
        return label
    }()
    
    override func prepareForReuse() {
        self.imageView.image = nil
        self.recipeNameLabel.text = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let padding: CGFloat = 1
        let viewOrigin = self.bounds.origin
        let imageViewHeight = self.bounds.height * 3/4
        let recipeNameLabelHeight = self.bounds.height - padding - imageViewHeight

        let imageViewOrigin = CGPoint(x: 0,
                                      y: 0)
        self.imageView.frame = CGRect(origin: imageViewOrigin,
                                      size: CGSize(width: self.bounds.width, height: imageViewHeight))
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.backgroundColor = .lightGreen
        self.imageView.layer.borderWidth = 1.0
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.layer.borderColor = UIColor.black.cgColor
        self.contentView.addSubview(self.imageView)
        self.contentView.backgroundColor = UIColor.white

        self.recipeNameLabel.frame = CGRect(origin: CGPoint(x: imageViewOrigin.x,
                                                            y: viewOrigin.y + imageViewHeight + padding),
                                            size: CGSize(width: imageView.frame.width,
                                                         height: recipeNameLabelHeight))
        self.recipeNameLabel.numberOfLines = 2
        self.recipeNameLabel.lineBreakMode = .byCharWrapping
        self.recipeNameLabel.backgroundColor = .white
        self.contentView.addSubview(self.recipeNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
}
