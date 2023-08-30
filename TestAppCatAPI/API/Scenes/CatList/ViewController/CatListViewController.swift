//
//  CatListViewController.swift
//  TestAppCatAPI
//
//  Created by Dubko Siarhei on 30.08.23.
//

import Foundation
import UIKit

protocol CatListViewControllerProtocol {
    func setCats(cats: [Cat])
    func showLoading(load: Bool)
}

class CatListViewController: UICollectionViewController, CatListViewControllerProtocol {
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 2) - 15, height: 200)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        super.init(collectionViewLayout: layout)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private enum Constants {
        static let sceneTitle = "Cat Images"
        static let searchTitle = "Search by name"
        static let pullToRefreshText = "Pull to refresh"
    }
    
    var cats = [Cat]()
    var filteredCats = [Cat]()
    
    var presenter: CatListPresenterProtocol?
    
    private var userStartedDragging = false
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchTitle
        return searchController
    }()
    
    private lazy var refresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Constants.pullToRefreshText)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var dataSource: CatListDataSource = .init(cats: cats, hasSearchText: { [weak self] in
        self?.hasSearchText() ?? false
    })
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        collectionView?.dataSource = dataSource
        collectionView?.register(BreedCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        title = Constants.sceneTitle
        
        definesPresentationContext = true
        collectionView.refreshControl = refresh
        collectionView.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.center = collectionView.center
    }

    private func hasSearchText() -> Bool {
        if let text = searchController.searchBar.text {
            return !text.isEmpty
        }
        return false
    }
    
    @objc func refresh(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.fetchCats(page: 1)
        }
    }
    
    func setCats(cats: [Cat]) {
        self.cats = cats
        dataSource.updateCats(cats)
        collectionView.reloadData()
        refresh.endRefreshing()
    }
    
    func showLoading(load: Bool) {
        if load {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        userStartedDragging = true
    }
}

extension CatListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            dataSource.updateFilteredBreeds(with: searchText)
            collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if userStartedDragging && indexPath.item == cats.count - 1 {
            presenter?.loadMoreCats()
        }
    }
}
