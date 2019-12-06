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
    var recipesTable = [(String, [RecipeCellModel])]()
    
    let recipeCoursesTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    let headerHeight: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        presenter?.viewLoaded()
        
        for index in 0...10 {
            recipesTable.append(("\(index)", []))
        }
        
        for index in 0...10 {
            recipesTable[index].1 = []
            for _ in 0...5 {
                recipesTable[index].1.append(RecipeCellModel(id: 0, name: "lal sadllsad asd asd asdsad sad asdas as das dasd asd asd asdsd d a", image: UIImage(named: "sirius")!))
            }
            
        }

        self.recipeCoursesTableView.register(HistoryTableViewCell.self,
                                             forCellReuseIdentifier: "recipeCell")
        
        self.recipeCoursesTableView.frame = self.view.frame
        
        self.recipeCoursesTableView.dataSource = self
        self.recipeCoursesTableView.delegate = self
        
        self.view.addSubview(self.recipeCoursesTableView)
    }
    
}

extension CookHistoryViewController: CookHistoryPresenterOutputProtocol {
    func showHistory(_ cells: [(String, [RecipeCellModel])]) {
        self.recipesTable = cells
        self.recipeCoursesTableView.reloadData()
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
        
        let model = recipesTable[indexPath.row].1
        cell.recipesCollection = model
        cell.recipesCollectionView.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 30)
        textLabel.textAlignment = .center
        textLabel.backgroundColor = .blue
        textLabel.text = self.recipesTable[section].0
        
        let desiredWidth = tableView.bounds.size.width
        let size = textLabel.sizeThatFits(CGSize(width: desiredWidth,
                                                 height: .greatestFiniteMagnitude))
        textLabel.frame = CGRect(origin: .zero, size: CGSize(width: desiredWidth,
                                                             height: size.height))
        textLabel.backgroundColor = .lightGreen
        return textLabel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.presenter?.clickedOnCell(at: indexPath)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
}
