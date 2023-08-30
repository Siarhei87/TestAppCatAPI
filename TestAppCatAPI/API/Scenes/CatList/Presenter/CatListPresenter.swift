//
//  CatListPresenter.swift
//  TestAppCatAPI
//
//  Created by Dubko Siarhei on 30.08.23.
//

import Foundation

protocol CatListPresenterProtocol {
    func viewWillAppear()
    func didSelectRow(at indexPath: IndexPath)
    func fetchCats(page: Int)
    func loadMoreCats()
}

class CatListPresenter: CatListPresenterProtocol {
    private let interactor: CatListInteractorProtocol
    private let router: CatListRouterProtocol
    private let viewController: CatListViewControllerProtocol
    private var cats: [Cat]?
    private var currentPage = 1
    var isFetchingMoreCats = false
    var isLoading = false

    init(viewController: CatListViewControllerProtocol,
         interactor: CatListInteractorProtocol,
         router: CatListRouterProtocol)
    {
        self.viewController = viewController
        self.interactor = interactor
        self.router = router

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.fetchCats(page: self.currentPage)
        }
    }

    func viewWillAppear() {
        setCats()
    }

    func setCats() {
        let filteredCats = cats?.filter { $0.breeds != nil || $0.breeds?.first?.name != nil } ?? []
        let catByName = filteredCats.sorted { ($0.breeds?.first?.name ?? "") < ($1.breeds?.first?.name ?? "") }
        viewController.setCats(cats: catByName)
    }

    func didSelectRow(at indexPath: IndexPath) {
        if let cat = cats?[indexPath.row] {
            router.showDetail(cat: cat)
        } else {
            router.showAlert(with: "Error", message: "We could not find the cat details")
        }
    }

    func fetchCats(page: Int) {
        isLoading = true
        viewController.showLoading(load: isLoading)
        interactor.fetchCats(page: page, limit: 10) { cats, error in
            if let error = error {
                print("Error: \(error)")
            } else if let cats = cats {
                print("Fetched cats: \(cats)")
                self.cats = cats
                self.setCats()
                self.isLoading = false
                self.viewController.showLoading(load: self.isLoading)
            }
        }
    }

    func loadMoreCats() {
        if !isFetchingMoreCats {
            isFetchingMoreCats = true
            currentPage += 1
            interactor.fetchCats(page: currentPage, limit: 10, completion: { newCats, _ in
                if let newCats = newCats {
                    self.cats?.append(contentsOf: newCats)
                    self.setCats()
                }
                self.isFetchingMoreCats = false
            })
        }
    }
}
