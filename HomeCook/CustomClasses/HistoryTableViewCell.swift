//
//  HistoryTableViewCell.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 06/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol HistoryTableViewProtocol: class {
    func selectedRecipe(id: Int)
}

class HistoryTableViewCell: UITableViewCell {
    let recipesCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    weak var delegate: HistoryTableViewProtocol?
    
    var recipesCollection = [RecipeCellModel]()
    
    let insetX: CGFloat = 10
    let insetY: CGFloat = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.recipesCollectionView.register(HistoryRecipeCell.self,
                                            forCellWithReuseIdentifier: "reuseId")
        
        self.recipesCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let frame = CGRect(origin: .zero, size: CGSize(width: self.bounds.width,
                                                       height: self.bounds.height))
        self.recipesCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX,
                                                               bottom: insetY, right: insetX)
        self.recipesCollectionView.frame = frame
        self.recipesCollectionView.dataSource = self
        self.recipesCollectionView.delegate = self
        self.contentView.addSubview(recipesCollectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func maximumSizeOfImageForCell(actualSize: CGSize, heightConstant: CGFloat) -> CGSize {
        let oldSize = actualSize
        let scale = heightConstant / oldSize.height;
        
        let newHeight = scale * oldSize.height
        let newWidth = scale * oldSize.width
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
}

extension HistoryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recipesCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseId", for: indexPath) as! HistoryRecipeCell
        
        let model = self.recipesCollection[indexPath.row]
        cell.recipeNameLabel.text = model.name
        cell.imageView.image = model.image
        
        return cell
    }
}

extension HistoryTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeId = self.recipesCollection[indexPath.row].id
        self.delegate?.selectedRecipe(id: recipeId)
    }
}

extension HistoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageHeightInCell = 3/4 * self.frame.height - insetY * 2
        var width = imageHeightInCell // image is in square
        
        if let oldImage = self.recipesCollection[indexPath.row].image {
            let newSize = maximumSizeOfImageForCell(actualSize: oldImage.size,
                                                    heightConstant: imageHeightInCell)
            if newSize.width > (width / 2) {
                width = newSize.width
            }
        }
        
        let itemWidth = width
        let itemHeight = self.frame.height - insetY * 2 - 1
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
