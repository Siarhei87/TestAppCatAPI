//
//  CatListInteractor.swift
//  TestAppCatAPI
//
//  Created by Dubko Siarhei on 30.08.23.
//

import Foundation

protocol CatListInteractorProtocol {
    func fetchCats(page: Int, limit: Int, completion: @escaping ([Cat]?, Error?) -> Void)
}

class CatListInteractor: CatListInteractorProtocol {
    private let repository: CatsRepositoryProtocol

    init(repository: CatsRepositoryProtocol) {
        self.repository = repository
    }

    func fetchCats(page: Int, limit: Int, completion: @escaping ([Cat]?, Error?) -> Void) {
        repository.fetchRandomCat(page: page, limit: limit, completion: completion)
    }
}
