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
        self.ingredients[1] = bought
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
        
        let padding: CGFloat = 5
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.text = model.name
        
        let desiredSize = CGSize(width: tableView.frame.width,
                                 height: CGFloat.greatestFiniteMagnitude)
        let nameFittedSize = nameLabel.sizeThatFits(desiredSize)
        
        let amountLabel = UILabel()
        amountLabel.text = String(model.amount)
        let amountFittedSize = amountLabel.sizeThatFits(CGSize(width: tableView.frame.width,
                                                                    height: 100))
       
        return nameFittedSize.height + padding + amountFittedSize.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let name = self.sectionNames[section]
        
        let frame = CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width,
                                                       height: self.headerHeight))
        let headerView = BuyIngredientHeaderView(frame: frame, section: section,
                                                 text: name, hide: self.hideSections[section])
        headerView.delegate = self
        return headerView
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
