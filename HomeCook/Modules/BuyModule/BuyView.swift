//
//  BuyView.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController {
    var presenter: BuyPresenterInputProtocol?
    
    var ingredients = [[IngredientBuyModel](), [IngredientBuyModel]()]
    let sectionNames = ["Active", "Purchased"]

    let ingredientsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()

    var hideSections = [Bool]()
    let cellReuseId = "ingredientCell"
    let headerHeight: CGFloat = 80
    let cellHeight: CGFloat = 80
    let zeroSectionFooterHeight: CGFloat = 20
    let headerPaddingX: CGFloat = 5
    
    let helpMessage = "Double TAP on section NAME to open / close"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(savePurchased), name:
            UIApplication.willResignActiveNotification, object: nil)
        
        self.presenter?.viewLoaded()
        
        self.view.backgroundColor = .darkGreen
        self.hideSections = Array.init(repeating: false, count: self.sectionNames.count)
        self.ingredientsTableView.dataSource = self
        self.ingredientsTableView.delegate = self
        self.ingredientsTableView.separatorColor = .darkGreen
        
        self.ingredientsTableView.register(IngredientTableViewCell.self,
                                           forCellReuseIdentifier: cellReuseId)
        
        self.view.addSubview(self.ingredientsTableView)
    }
    
    override func viewWillLayoutSubviews() {
        let frame = CGRect(origin: .zero, size: self.view.frame.size)
        
        self.ingredientsTableView.frame = frame
    }
    
    @objc func savePurchased() {
        self.presenter?.viewWillDisappear(bought: ingredients[1])
    }
    
    func showHint() {
        let helpAlertController = UIAlertController(title: "Hint", message: self.helpMessage, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            self.presenter?.alertWasShown()
        })
        helpAlertController.addAction(actionOk)
        self.present(helpAlertController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.presenter?.viewWillDisappear(bought: ingredients[1])
    }
}

extension BuyViewController: BuyPresenterOutputProtocol {
    func setIngredients(active: [IngredientBuyModel], bought: [IngredientBuyModel]) {
        self.ingredients[0] = active
        if active.count != 0 {
            self.ingredients[1] = bought
        }
        self.ingredientsTableView.reloadData()
    }
}

extension BuyViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredients[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! IngredientTableViewCell
        
        let model = self.ingredients[indexPath.section][indexPath.row]
        let amount = model.amount

        cell.setValues(name: model.name, amount: String(amount), unit: model.unit)
        
        var backgroundColor = UIColor.white
        var alpha: CGFloat = 1.0
        
        if model.amountBoughtStatus < 0 {
            backgroundColor = .yellow
        }
        cell.backgroundColor = backgroundColor
        
        if indexPath.section == 1 {
            alpha = 0.5
        }
        cell.contentView.alpha = alpha
        
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.hideSections[indexPath.section] {
            return 0.01
        }
        
        let model = self.ingredients[indexPath.section][indexPath.row]
        
        let nameLabel = UILabel()
        let amountLabel = UILabel()
        let unitLabel = UILabel()
        
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.text = model.name
        unitLabel.numberOfLines = 0
        
        let paddingX: CGFloat = 5
        let paddingY: CGFloat = 5
        let paddingBetweenY: CGFloat = 0
        let paddingBetweenX: CGFloat = 2
        
        unitLabel.lineBreakMode = .byWordWrapping
        
        amountLabel.text = String(model.amount)
        unitLabel.text = model.unit
        
        let ratio: CGFloat = 4/7
        let contentWidth = tableView.frame.width - paddingX
        let nameWidth = contentWidth * ratio
        let featureWidth = contentWidth - nameWidth - paddingBetweenX
        
        let amounDesiredSize = CGSize(width: featureWidth, height: CGFloat.greatestFiniteMagnitude)
        let amountFittedSize = amountLabel.sizeThatFits(amounDesiredSize)
        
        let desiredUnitSize = CGSize(width: featureWidth, height: CGFloat.greatestFiniteMagnitude)
        let unitFittedSize = unitLabel.sizeThatFits(desiredUnitSize)
        
        let nameDesiredSize = CGSize(width: nameWidth, height: CGFloat.greatestFiniteMagnitude)
        let nameFittedSize = nameLabel.sizeThatFits(nameDesiredSize)
        
        let featuresTotalHeight = amountFittedSize.height + paddingBetweenY + unitFittedSize.height
        let heightDifference = featuresTotalHeight - nameFittedSize.height
        
        let cellHeight = 2 * paddingY + (heightDifference > 0 ? featuresTotalHeight : nameFittedSize.height)
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let name = self.sectionNames[section]
        let headerSuperView = UIView()
        headerSuperView.frame = CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width,
                                                                   height: self.headerHeight))
        
        let size = CGSize(width: self.view.bounds.width - headerPaddingX, height: self.headerHeight)
        let frame = CGRect(origin: CGPoint(x: headerPaddingX, y: 0), size: size)
        let headerView = BuyIngredientHeaderView(frame: frame, section: section,
                                                 text: name, hide: self.hideSections[section])
        headerView.delegate = self
        headerSuperView.backgroundColor = headerView.backgroundColor
        headerSuperView.addSubview(headerView)
        return headerSuperView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(origin: .zero,
                                    size: CGSize(width: self.view.bounds.width,
                                                 height: self.zeroSectionFooterHeight)))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.zeroSectionFooterHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oldSection = indexPath.section
        let newSection = 1 - indexPath.section
        let removed = self.ingredients[oldSection].remove(at: indexPath.row)
        self.ingredients[newSection].insert(removed, at: 0)
        tableView.reloadData()
    }
}

extension BuyViewController: BuyIngredientHeaderDelegate {
    func changeVisibility(for section: Int, hide: Bool) {
        self.hideSections[section] = hide
        if hideSections.contains(false) == false {
            self.ingredientsTableView.separatorColor = .clear
        } else {
            self.ingredientsTableView.separatorColor = .darkGreen
        }
      
        self.ingredientsTableView.reloadData()
    }
}
