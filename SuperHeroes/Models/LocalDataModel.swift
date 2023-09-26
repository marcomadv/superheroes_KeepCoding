//
//  LocalDataModel.swift
//  SuperHeroes
//
//  Created by Marco Muñoz on 21/9/23.
//

import Foundation

struct LocalDataModel {
    private static let key = "SuperHeroesToken"
    
    private static let userDefaults = UserDefaults.standard //objeto singleton, el ciclo de vida es igual al de la app
    
    static func getToken() -> String? {
        userDefaults.string(forKey: key)
    }
    
    static func save(token:String) {
        userDefaults.set(token, forKey: key)
    }
    
    static func deleteToken() {
        userDefaults.removeObject(forKey: key)
    }
}
