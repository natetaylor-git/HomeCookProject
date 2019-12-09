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
    var ingredients = [IngredientModel]()
    let sectionsNames = ["Active", "Bought"]
    
    let buyButton: ImageButton = {
        let button = ImageButton(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)), imageName: "BuyIconDetailed", brightColor: .blue, shadow: true)
        return button
    }()
    
    let ingredientsTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var deleteButton: UIBarButtonItem?
    
    let headerHeight: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter?.viewLoaded()
        
        self.deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(tappedDeleteButton))
    }
    
    override func viewWillLayoutSubviews() {
        let navigationHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let viewSize = self.view.frame.size
        let size = CGSize(width: viewSize.width,
                          height: viewSize.height - navigationHeight)
        let frame = CGRect(origin: .zero, size: size)
        
        self.ingredientsTableView.frame = frame
        
        let navigationItem = self.navigationController?.topViewController?.navigationItem
        navigationItem?.rightBarButtonItem = self.deleteButton
    }
    
    @objc func tappedDeleteButton() {
        self.ingredients.removeAll()
        self.ingredientsTableView.reloadData()
    }
}

extension BuyViewController: BuyPresenterOutputProtocol {
    
}

extension BuyViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let name = self.sectionsNames[section]
        
//        
//        let desiredWidth = tableView.bounds.size.width
//        let size = textLabel.sizeThatFits(CGSize(width: desiredWidth,
//                                                 height: .greatestFiniteMagnitude))
//        textLabel.frame = CGRect(origin: .zero, size: CGSize(width: desiredWidth,
//                                                             height: size.height))
//        //        textLabel.layer.borderColor = UIColor.black.cgColor
//        //        textLabel.layer.borderWidth = 1.0
//        //        textLabel.backgroundColor = .darkGreen
//        //        textLabel.textColor = .white
//        textLabel.backgroundColor = .white
//        textLabel.textColor = .black
////        drawBottomLine(for: textLabel)
//        
//        let headerView = BuyIngredientHeaderView(frame: <#T##CGRect#>, section: <#T##Int#>, text: <#T##String#>)
//        return textLabel
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
