//
//  CookViewController.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class CookCurrentViewController: UIViewController {
    var presenter: CookCurrentPresenterInputProtocol?
    
    let recipesCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        pageControl.backgroundColor = .black
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .lightGreen
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    let recipeNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .blue
        return label
    }()
    
    var pages = [(name: String, image: UIImage, instructions: String)]()
    let insetX: CGFloat = 0
    let insetY: CGFloat = 0
    let pageControlHeight: CGFloat = 10
    let pageControlWidthMargin: CGFloat = 2
    let recipeNumberLabelHeight: CGFloat = 30
    var lastPageNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter?.viewLoaded()
        
        self.recipesCollectionView.dataSource = self
        self.recipesCollectionView.delegate = self
        self.recipesCollectionView.isPagingEnabled = true
        self.recipesCollectionView.register(CurrentRecipeCell.self,
                                            forCellWithReuseIdentifier: "currentRecipe")
        self.recipesCollectionView.bounces = false
        self.pageControl.numberOfPages = self.pages.count
        
        self.view.addSubview(recipesCollectionView)
        self.view.addSubview(self.pageControl)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPageNumber = Int(self.recipesCollectionView.contentOffset.x) /
            Int(self.recipesCollectionView.frame.width)
        self.pageControl.currentPage = currentPageNumber
        
        if currentPageNumber != self.lastPageNumber {
            let navigationItem = self.navigationController?.topViewController?.navigationItem
            navigationItem?.title = self.pages[currentPageNumber].name
            updatePageNumberLabel(with: currentPageNumber + 1)
            self.lastPageNumber = currentPageNumber
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.pageControl.alpha = 1.0
    }

    override func viewWillLayoutSubviews() {
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        let viewSize = self.view.frame.size
        let size = CGSize(width: viewSize.width,
                          height: viewSize.height - tabBarHeight)
        let frame = CGRect(origin: .zero, size: size)
        
        let insets = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        self.recipesCollectionView.contentInset = insets
        self.recipesCollectionView.frame = frame
        
        layoutPageControl()
    }
    
    func layoutPageControl() {
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        let viewSize = self.view.frame.size
        
        var pageControlWidth: CGFloat
        let desiredlSize = self.pageControl.size(forNumberOfPages: self.pageControl.numberOfPages)
        if desiredlSize.width > viewSize.width {
            pageControlWidth = viewSize.width
        } else {
            pageControlWidth = desiredlSize.width
        }
        
        let pageControlSize = CGSize(width: pageControlWidth, height: self.pageControlHeight)
        let pageControlOriginY = self.view.frame.maxY - pageControlSize.height - tabBarHeight
        let pageControlOrigin = CGPoint(x: (viewSize.width - pageControlWidth) / 2,
                                        y: pageControlOriginY)
        
        self.pageControl.frame = CGRect(origin: pageControlOrigin, size: pageControlSize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.presenter?.viewWillAppear()
        
        let navigationItem = self.navigationController?.topViewController?.navigationItem
        
        var title = "No recipes to cook"
        if self.pages.count != 0 {
            title = self.pages[self.pageControl.currentPage].name
            
            let recipeNumber = self.pageControl.currentPage + 1
            updatePageNumberLabel(with: recipeNumber)
            
            let item = UIBarButtonItem(customView: recipeNumberLabel)
            navigationItem?.rightBarButtonItem = item
        }
        navigationItem?.title = title
    }
    
    func updatePageNumberLabel(with number: Int) {
        if number == 0 {
            return
        }
        let navigationItem = self.navigationController?.topViewController?.navigationItem
        self.recipeNumberLabel.text = "#\(number)"
        
        var minX: CGFloat
        if let titleMaxY = navigationItem?.titleView?.frame.maxY {
            minX = titleMaxY
        } else {
            minX = self.view.frame.width / 2
        }
        
        let desiredSize = recipeNumberLabel.sizeThatFits(CGSize(width: self.view.frame.width - minX,
                                                                height: self.recipeNumberLabelHeight))
        let recipeNumberLabelOrigin = CGPoint(x: 0, y: 0)
        self.recipeNumberLabel.frame = CGRect(origin: recipeNumberLabelOrigin,
                                              size: desiredSize)
    }
}

extension CookCurrentViewController: CurrentRecipeCellDelegate {
    func changePageControlVisibility() {
        self.pageControl.alpha = 0
    }
}

extension CookCurrentViewController: CookCurrentPresenterOutputProtocol {
    func updateCollectionView(with recipes: [(name: String, image: UIImage, instructions: String)]) {
        self.pages = recipes
        self.pageControl.numberOfPages = self.pages.count
        layoutPageControl()
        self.recipesCollectionView.reloadData()
    }
}

extension CookCurrentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "currentRecipe", for: indexPath) as! CurrentRecipeCell
        
        let model = self.pages[indexPath.row]
        cell.delegate = self
        cell.setText(model.instructions)
        cell.imageView.image = model.image
        cell.setScrollViewInset(with: self.pageControl.frame.height)
        
        return cell
    }
}

extension CookCurrentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension CookCurrentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
