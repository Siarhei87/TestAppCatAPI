//
//  CatsRepository.swift
//  TestAppCatAPI
//
//  Created by Dubko Siarhei on 30.08.23.
//

import Foundation
import UIKit

protocol CatsRepositoryProtocol {
    func fetchRandomCat(page: Int, limit: Int, completion: @escaping ([Cat]?, Error?) -> Void)
}

class CatsRepository: CatsRepositoryProtocol {
    func fetchRandomCat(page: Int = 1, limit: Int = 10, completion: @escaping ([Cat]?, Error?) -> Void) {
        let urlString = "https://api.thecatapi.com/v1/images/search?limit=\(limit)&page=\(page)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.setValue("live_fAaLH1NuQeiD1MhciPu6HMoZUuVGSdVtN362lpJWUOxSLGP2PxSgEQxazXA2mOXU", forHTTPHeaderField: "x-api-key")

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data was not retrieved"]))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print(json)
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }

            do {
                let decoder = JSONDecoder()
                var сats = try decoder.decode([Cat].self, from: data)
                let group = DispatchGroup()

                for (index, cat) in сats.enumerated() {
                    group.enter()

                    self.fetchCatDetails(byId: cat.id) { catDetails, error in
                        if let error = error {
                            print("Error fetching cat details:", error)
                        } else if let catDetails = catDetails {
                            var updatedCat = cat
                            updatedCat.breeds = catDetails.breeds
                            сats[index] = updatedCat
                            print("Cat details:", catDetails)
                        }
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    completion(сats, nil)
                }

            } catch let decodingError {
                completion(nil, decodingError)
            }
        }

        task.resume()
    }

    func fetchCatDetails(byId id: String, completion: @escaping (Cat?, Error?) -> Void) {
        let urlString = "https://api.thecatapi.com/v1/images/\(id)"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "No data", code: 0, userInfo: nil))
                return
            }

            do {
                let decoder = JSONDecoder()
                let catDetails = try decoder.decode(Cat.self, from: data)
                completion(catDetails, nil)
            } catch let decodeError {
                completion(nil, decodeError)
            }
        }.resume()
    }
}
