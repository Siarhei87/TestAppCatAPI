//
//  CatListDataSource.swift
//  TestAppCatAPI
//
//  Created by Dubko Siarhei on 30.08.23.
//

import Foundation
import UIKit

class CatListDataSource: NSObject, UICollectionViewDataSource {
    private var cats = [Cat]()
    private var filteredCats = [Cat]()
    private var hasSearchText: () -> Bool

    init(cats: [Cat], hasSearchText: @escaping () -> Bool) {
        self.cats = cats
        self.hasSearchText = hasSearchText
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hasSearchText() ? filteredCats.count : cats.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "cell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! BreedCollectionViewCell

        let cat = hasSearchText() ? filteredCats[indexPath.row] : cats[indexPath.row]
        cell.titleLabel.text = cat.breeds?.first?.name
        cell.imageView.setImageFromURL(cat.url)
        return cell
    }

    func updateCats(_ cats: [Cat]) {
        self.cats = cats
    }

    func updateFilteredBreeds(with searchText: String) {
        filteredCats = cats.filter { cat in
            let name = cat.breeds?.first?.name ?? ""
            return name.contains(searchText)
        }
    }
}
