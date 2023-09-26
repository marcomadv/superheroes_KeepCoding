//
//  Transformation.swift
//  SuperHeroes
//
//  Created by Marco Muñoz on 20/9/23.
//

import Foundation

struct Transformation: Decodable {
    let id: String
    let name: String
    let description: String
    let photo: URL
}

extension Transformation: HeroeAndTransformationProtocol {}


