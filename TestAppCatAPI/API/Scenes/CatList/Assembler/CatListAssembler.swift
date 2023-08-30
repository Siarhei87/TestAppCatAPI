//
//  CatListAssembler.swift
//  TestAppCatAPI
//
//  Created by Dubko Siarhei on 30.08.23.
//

import Foundation
import UIKit

protocol CatListAssemblerProtocol {
    static func resolveViewController() -> UIViewController
    static func resolvePresenter(viewController: CatListViewControllerProtocol, router: CatListRouterProtocol) -> CatListPresenterProtocol
}

class CatListAssembler: CatListAssemblerProtocol {
    static func resolveViewController() -> UIViewController {
        let viewController = CatListViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        let router = CatListRouter(navigationController: navigationController)

        let presenter = resolvePresenter(viewController: viewController, router: router)
        viewController.presenter = presenter

        return navigationController
    }

    static func resolvePresenter(viewController: CatListViewControllerProtocol, router: CatListRouterProtocol) -> CatListPresenterProtocol {
        let repository = CatsRepository()
        let interactor = CatListInteractor(repository: repository)

        return CatListPresenter(viewController: viewController,
                                interactor: interactor,
                                router: router)
    }
}
