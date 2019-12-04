//
//  SearchViewController.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 29/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    var presenter: SearchPresenterInputProtocol?
    var clickedOnCell: ((DetailedRecipeEntity) -> Void)?
    var searchResultsCollection = [RecipeCellModel]()
    
    let recipesSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    let searchResultsTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    let filterButton: ImageButton = {
        let button = ImageButton(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)),
                                 imageName: "FilterIcon")
        return button
    }()
    
    var filtersVisible = false
    var filtersView = FiltersView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        self.recipesSearchBar.delegate = self
        self.searchResultsTableView.dataSource = self
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.register(SearchRecipeCell.self, forCellReuseIdentifier: "reuseId")
        
        self.presenter?.viewLoaded()
    }
    
    func setupUI() {
        self.navigationItem.title = "Search"
        self.navigationItem.largeTitleDisplayMode = .never
        setupFiltersButton()
        setupFiltersView()
        setupRecipesSearchBar()
        setupSearchResultsTableView()
    }
    
    func setupFiltersButton() {
        self.filterButton.addTarget(self, action: #selector(tappedFiltersButton), for: .touchUpInside)
        let item = UIBarButtonItem(customView: self.filterButton)
        self.navigationItem.rightBarButtonItem = item
    }
    
    func setupFiltersView() {
        registerKeyboardNotifications()
        var paddingSearchBarY: CGFloat = .zero
        if let navigationBar = self.navigationController?.navigationBar {
            paddingSearchBarY = navigationBar.frame.origin.y + navigationBar.frame.height
        }

        let filtersViewFrame = CGRect(origin: CGPoint(x: self.view.frame.width, y: paddingSearchBarY),
                                      size: CGSize(width: self.view.frame.width,
                                                   height: self.filtersView.titleLabel.frame.height))
        self.filtersView.setup(filtersData: [], frame: filtersViewFrame)
        self.filtersView.alpha = 0.0
        
        self.view.addSubview(self.filtersView)
    }
    
    func setupRecipesSearchBar() {
        self.recipesSearchBar.showsBookmarkButton = true
        self.recipesSearchBar.enablesReturnKeyAutomatically = false
        var paddingSearchBarY: CGFloat = .zero
        if let navigationBar = self.navigationController?.navigationBar {
            paddingSearchBarY = navigationBar.frame.origin.y + navigationBar.frame.height
        }
        self.recipesSearchBar.frame = CGRect(origin: CGPoint(x: .zero, y: paddingSearchBarY),
                                             size: CGSize(width: self.view.frame.width, height: 70))
        self.recipesSearchBar.barTintColor = UIColor.lightGreen
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

    func setupFilters() {
        
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func onKeyboardAppear(notification: NSNotification) {
        let info = notification.userInfo
        let rect: CGRect = info?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let keyboardSize = rect.size
        
        let bottomInset = keyboardSize.height - (UIScreen.main.bounds.maxY - self.filtersView.frame.maxY)
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        filtersView.contentInset = insets
    }
    
    @objc func onKeyboardDisappear(notification: NSNotification) {
        filtersView.contentInset = UIEdgeInsets.zero
    }
    
    @objc func tappedFiltersButton() {
        self.filterButton.changeImageColor()
        if self.filtersVisible {
            doFilterExistingResults()
            self.view.endEditing(true)
            self.filtersVisible = false
            self.searchResultsTableView.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.5) {
                self.filtersView.alpha = 0.0
                self.searchResultsTableView.alpha = 1.0
                self.filtersView.frame.origin = CGPoint(x: self.view.frame.width,
                                                        y: self.filtersView.frame.origin.y)
            }
        } else {
            self.filtersVisible = true
            self.searchResultsTableView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.5) {
                self.filtersView.alpha = 1.0
                self.searchResultsTableView.alpha = 0.5
                self.filtersView.frame.origin = CGPoint(x: 0, y: self.filtersView.frame.origin.y)
                self.view.bringSubviewToFront(self.filtersView)
            }
        }
    }
    
    func doFilterExistingResults() {
        
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseId", for: indexPath) as! SearchRecipeCell
        
        let model = searchResultsCollection[indexPath.row]

        
        cell.textLabel?.text = model.name
        cell.imageView?.image = model.image
        if cell.imageView?.image != nil {
            cell.isUserInteractionEnabled = true
        } else {
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.clickedOnCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let rows = indexPaths.map{$0.row}
        let downloadAtOffset: Int = 10
        let totalRowsNumber = self.searchResultsCollection.count
        let tenthFromEndNumber = totalRowsNumber - downloadAtOffset
        if rows.contains(tenthFromEndNumber) {
            self.presenter?.prefetchCalled()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        self.searchResultsCollection.removeAll()
        self.presenter?.searchButtonClicked(with: text)
        self.view.endEditing(true)
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        self.presenter?.prefetchCalled()
    }
}

extension SearchViewController: SearchPresenterOutputProtocol {
    func callCompletion(with detailedRecipe: DetailedRecipeEntity) {
        self.clickedOnCell?(detailedRecipe)
    }
    
    func updateResults(with recipesCellModels: [RecipeCellModel]) {
        self.searchResultsCollection += recipesCellModels
        self.searchResultsTableView.reloadData()
    }
    
    func updateResult(at indexPath: IndexPath, with image: UIImage) {
        self.searchResultsCollection[indexPath.row].image = image
        self.searchResultsTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func updateFiltersView(with parameters: [(String, [String])]) {
        var paddingFilterViewY: CGFloat = .zero
        if let navigationBar = self.navigationController?.navigationBar {
            paddingFilterViewY = navigationBar.frame.origin.y + navigationBar.frame.height
        }
        
        let size = CGSize(width: self.filtersView.frame.width,
                          height: (self.view.frame.maxY - paddingFilterViewY))
        let filtersViewFrame = CGRect(origin: self.filtersView.frame.origin,
                                      size: size)
        self.filtersView.setup(filtersData: parameters, frame: filtersViewFrame)
    }
}
