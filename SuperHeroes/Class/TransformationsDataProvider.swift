//
//  TransformationsDataProvider.swift
//  SuperHeroes
//
//  Created by Pedro Muñoz Cabrera on 26/9/23.
//

import Foundation

class TransformationsDataPRovider: ListDataProviderProtocol {
    
    var title: String = "Transformations"
    private var data: [HeroeAndTransformationProtocol] = []
    init(data: [HeroeAndTransformationProtocol]) {
        self.data = data
    }
    
    func refreshData(completion: @escaping (([HeroeAndTransformationProtocol]) -> ())) {
        completion(data)
    }
}
