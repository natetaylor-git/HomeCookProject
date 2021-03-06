//
//  CookHistoryViewController.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class CookHistoryViewController: UIViewController {
    var presenter: CookHistoryPresenterInputProtocol?
    var clickedOnCell: ((DetailedRecipeEntity) -> Void)?
    var recipesTable = [(String, [RecipeCellModel])]()
    
    let recipeCoursesTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .black
        return indicator
    }()
    
    let headerHeight: CGFloat = 40
    let indicatorSide: CGFloat = 80
    let indicatorScale: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupIndicator()
        self.indicator.startAnimating()
        presenter?.viewLoaded()
        
        self.recipeCoursesTableView.separatorColor = .clear
        self.recipeCoursesTableView.register(HistoryTableViewCell.self,
                                             forCellReuseIdentifier: "recipeCell")
        
        self.recipeCoursesTableView.frame = self.view.frame
        
        self.recipeCoursesTableView.dataSource = self
        self.recipeCoursesTableView.delegate = self
        
        self.view.addSubview(self.recipeCoursesTableView)
        self.view.addSubview(self.indicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navigationItem = self.navigationController?.topViewController?.navigationItem
        navigationItem?.title = "Cooked Recipes"
        navigationItem?.rightBarButtonItem = nil
    }
    
    func setupIndicator() {
        let viewBounds = self.view.bounds
        let origin = CGPoint(x: (viewBounds.width - indicatorSide) / 2,
                             y: (viewBounds.height - indicatorSide) / 2)
        self.indicator.frame = CGRect(origin: origin, size: CGSize(width: indicatorSide,
                                                                   height: indicatorSide))
        self.indicator.transform = CGAffineTransform(scaleX: self.indicatorScale,
                                                     y: self.indicatorScale)
    }
}

extension CookHistoryViewController: CookHistoryPresenterOutputProtocol {
    func showHistory(_ cells: [(String, [RecipeCellModel])]) {
        self.recipesTable = cells
        self.recipeCoursesTableView.reloadData()
        self.indicator.stopAnimating()
    }
    
    func callCompletion(with entity: DetailedRecipeEntity) {
        self.clickedOnCell?(entity)
    }
    
    func stopIndicator() {
        self.indicator.stopAnimating()
    }
}

extension CookHistoryViewController: HistoryTableViewProtocol {
    func selectedRecipe(id: Int) {
        self.presenter?.clickedOnRecipe(id: id)
    }
}

extension CookHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return recipesTable.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! HistoryTableViewCell
        
        let model = recipesTable[indexPath.section].1
        cell.delegate = self
        cell.recipesCollection = model
        cell.recipesCollectionView.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let textLabel = UILabel()
        textLabel.font = UIFont.boldSystemFont(ofSize: 30)
        textLabel.textAlignment = .left
        textLabel.text = " " + self.recipesTable[section].0.capitalized
        
        let desiredWidth = tableView.bounds.size.width
        let size = textLabel.sizeThatFits(CGSize(width: desiredWidth,
                                                 height: .greatestFiniteMagnitude))
        textLabel.frame = CGRect(origin: .zero, size: CGSize(width: desiredWidth,
                                                             height: size.height))
        textLabel.backgroundColor = .white
        textLabel.textColor = .black
        drawBottomLine(for: textLabel)
        return textLabel
    }
}

extension CookHistoryViewController {
    func drawBottomLine(for view: UIView, width: CGFloat = 2.0) {
        let path = UIBezierPath()
        let levelY = view.frame.origin.y + headerHeight
        path.move(to: CGPoint(x: 0, y: levelY))
        path.addLine(to: CGPoint(x: view.frame.maxX, y: levelY))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.darkGreen.cgColor
        shapeLayer.lineWidth = width
        view.layer.addSublayer(shapeLayer)
    }
}
