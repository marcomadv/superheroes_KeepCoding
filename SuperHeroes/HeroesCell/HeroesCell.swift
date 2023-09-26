//
//  Cell.swift
//  SuperHeroes
//
//  Created by Marco Muñoz on 24/9/23.
//

import UIKit

class HeroesCell: UITableViewCell {
    static let identifier = "HeroesCell"
    
    // MARK: - Outlets
    @IBOutlet weak var heroeImage: UIImageView!
    @IBOutlet weak var heroeName: UILabel!
    @IBOutlet weak var heroeDetail: UILabel!
    
    func configure(with heroe: any HeroeAndTransformationProtocol){
        
        heroeImage.setImage(for: heroe.photo)
        heroeName.text = heroe.name
        heroeDetail.text = heroe.description
    }
}
