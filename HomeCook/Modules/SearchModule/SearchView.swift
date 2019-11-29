//
//  SearchViewController.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    let recipesSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    let searchResultsTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        

        self.navigationItem.title = "Search"
    }
    
    func setupUI() {
        setupRecipesSearchBar()
        setupSearchResultsTableView()
    }
    
    func setupRecipesSearchBar() {
        var paddingSearchBarY: CGFloat = .zero
        if let navigationBar = self.navigationController?.navigationBar {
            paddingSearchBarY = navigationBar.frame.origin.y + navigationBar.frame.height
        }
        self.recipesSearchBar.frame = CGRect(origin: CGPoint(x: .zero, y: paddingSearchBarY),
                                             size: CGSize(width: self.view.frame.width, height: 100))
        
        self.view.addSubview(recipesSearchBar)
    }
    
    func setupSearchResultsTableView() {
        let origin = CGPoint(x: .zero, y: self.recipesSearchBar.frame.maxY)
        let size = CGSize(width: self.view.frame.width,
                          height: self.view.frame.maxY - self.recipesSearchBar.frame.maxY)
        self.searchResultsTableView.frame = CGRect(origin: origin,
                                                   size: size)
        self.view.addSubview(searchResultsTableView)
    }

}
