//
//  HistoryCookCell.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

/// Class for history cell in collection view
class HistoryRecipeCell: UICollectionViewCell {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var recipeNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
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
        let imageViewHeight = self.bounds.height * 5/6
        let recipeNameLabelHeight = self.bounds.height - padding - imageViewHeight

        let imageViewOrigin = CGPoint(x: 0,
                                      y: 0)
        self.imageView.frame = CGRect(origin: imageViewOrigin,
                                      size: CGSize(width: self.bounds.width, height: imageViewHeight))
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.backgroundColor = .black
        self.imageView.layer.masksToBounds = true
        
        self.imageView.layer.cornerRadius = 10.0
        self.contentView.addSubview(self.imageView)

        let nameOrigin = CGPoint(x: imageViewOrigin.x, y: viewOrigin.y + imageViewHeight + padding)
        let nameSize = CGSize(width: imageView.frame.width, height: recipeNameLabelHeight)
        self.recipeNameLabel.frame = CGRect(origin: nameOrigin, size: nameSize)
        self.recipeNameLabel.numberOfLines = 2
        self.recipeNameLabel.lineBreakMode = .byCharWrapping
        self.recipeNameLabel.layer.cornerRadius = 10.0
        self.recipeNameLabel.layer.masksToBounds = true
        
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
