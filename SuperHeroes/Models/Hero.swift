//
//  Hero.swift
//  SuperHeroes
//
//  Created by Marco Muñoz on 19/9/23.
//

import Foundation

struct Hero: Decodable {
    let id: String
    let name: String
    let description: String
    let photo: URL
    let favorite: Bool
}

 extension Hero: HeroeAndTransformationProtocol {}

// MARK: - Custom Decodable Conformance
/*
extension Hero: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case photo
        case favorite
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        photo = try values.decode(URL.self, forKey: .photo)
        favorite = try values.decode(Bool.self, forKey: .favorite)
    }
}
*/



