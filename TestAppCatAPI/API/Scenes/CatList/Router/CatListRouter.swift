//
//  CatListRouter.swift
//  TestAppCatAPI
//
//  Created by Dubko Siarhei on 30.08.23.
//

import Foundation
import UIKit

protocol CatListRouterProtocol {
    func showDetail(cat: Cat)
    func showAlert(with title: String, message: String)
    var navigationController: UINavigationController { get }
}

class CatListRouter: CatListRouterProtocol {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func showDetail(cat: Cat) {
        
        guard let url = URL(string: cat.breeds?.first?.wikipedia_url ?? "") else {
          return
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        navigationController.present(alert, animated: true, completion: nil)
    }
}
