//
//  HeroesDataProvider.swift
//  SuperHeroes
//
//  Created by Marco Muñoz on 26/9/23.
//

import Foundation

class HeroesDataPRovider: ListDataProviderProtocol {
    
    var title: String = "Heroes"
    private let model = NetworkModel()
    
    func refreshData(completion: @escaping (([HeroeAndTransformationProtocol]) -> ())) {
        self.model.getHeroes { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(heroes):
                    completion(heroes)
                case let .failure(error):
                    completion([])
                    print("Error: \(error)")
                }
            }
        }
    }
}
