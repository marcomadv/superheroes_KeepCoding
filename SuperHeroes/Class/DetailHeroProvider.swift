//
//  DetailHeroProvider.swift
//  SuperHeroes
//
//  Created by Marco Muñoz on 27/9/23.
//

import Foundation

class DetailHeroProvider: DetailDataProviderProtocol {
    var detailInfo: HeroeAndTransformationProtocol
    
    init(detailInfo: HeroeAndTransformationProtocol) {
        self.detailInfo = detailInfo
    }
}
