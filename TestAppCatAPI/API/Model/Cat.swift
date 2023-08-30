//
//  Cat.swift
//  TestAppCatAPI
//
//  Created by Dubko Siarhei on 30.08.23.
//

import Foundation
import UIKit

struct Cat: Codable {
    var id: String
    var url: String
    var breeds: [Breed]?
    var width: Int
    var height: Int
}

struct Breed: Codable {
    var weight: Weight
    var id: String
    var name: String
    var wikipedia_url: String

    enum CodingKeys: String, CodingKey {
        case weight
        case id
        case name
        case wikipedia_url
    }
}

struct Weight: Codable {
    let imperial: String
    let metric: String
}
