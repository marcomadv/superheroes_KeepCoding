//
//  ListProviderProtocol.swift
//  SuperHeroes
//
//  Created by Pedro Muñoz Cabrera on 26/9/23.
//

import Foundation

protocol ListDataProviderProtocol {
    
    var title: String { get }
    func refreshData(completion: @escaping (([HeroeAndTransformationProtocol]) -> ()))
}
