//
//  ListProviderProtocol.swift
//  SuperHeroes
//
//  Created by Marco Muñoz on 26/9/23.
//

import Foundation

protocol ListDataProviderProtocol {
    
    var title: String { get }
    func refreshData(completion: @escaping (([HeroeAndTransformationProtocol]) -> ()))
}
