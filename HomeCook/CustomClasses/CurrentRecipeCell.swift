//
//  CurrentRecipesCell.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 06/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol CurrentRecipeCellDelegate: class {
    func changePageControlVisibility()
}

/// Class for cell in collectionView presented on current recipes screen
class CurrentRecipeCell: UICollectionViewCell {
    weak var delegate: CurrentRecipeCellDelegate?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGreen
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5.0
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var instructionsView: RecipeDetailView?
    
    let paddingX: CGFloat = 10
    let paddingBetweenElements: CGFloat = 10
    let labelHeight: CGFloat = 100
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.scrollView.delegate = self
        let scrollViewSize = CGSize(width: self.bounds.width, height: self.bounds.height)
        self.scrollView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: scrollViewSize)
    
        let scrollViewBounds = self.scrollView.bounds
        let origin = CGPoint(x: paddingX, y: 0)
        let size = CGSize(width: scrollViewBounds.width - 2 * paddingX,
                          height: scrollViewBounds.height / 2)
        
        self.imageView.frame = CGRect(origin: origin, size: size)
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width,
                                             height: self.imageView.frame.height)
        self.scrollView.addSubview(self.imageView)
        
        let labelWidth = self.imageView.frame.width
        let originLabel = CGPoint(x: self.paddingX,
                                  y: self.imageView.frame.maxY + paddingBetweenElements)
        let sizeLabel = CGSize(width: labelWidth, height: labelHeight)
        
        let frame = CGRect(origin: originLabel, size: sizeLabel)
        let instructionsView = RecipeDetailView(frame: frame, name: "Instructions", value: "")
        self.scrollView.addSubview(instructionsView)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width,
                                             height: instructionsView.frame.maxY)
        self.instructionsView = instructionsView
        self.contentView.addSubview(self.scrollView)
    }
    
    func setText(_ value: String) {
        guard let instructionsView = self.instructionsView else {
            return
        }
        instructionsView.setupValueLabel(value: value)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width,
                                             height: instructionsView.frame.maxY)
    }
    
    func setScrollViewInset(with pageControlHeight: CGFloat) {
        self.scrollView.contentInset.bottom = pageControlHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension CurrentRecipeCell: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.delegate?.changePageControlVisibility()
    }
}
