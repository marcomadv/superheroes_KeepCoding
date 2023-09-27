//
//  DetailViewController.swift
//  SuperHeroes
//
//  Created by Marco Muñoz on 23/9/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
   
    @IBOutlet weak var heroeImage: UIImageView!
    @IBOutlet weak var heroeName: UILabel!
    @IBOutlet weak var transformationsButton: UIButton!
    @IBOutlet weak var heroeTextView: UITextView!
    @IBOutlet weak var constraintHeightButton: NSLayoutConstraint!
    
    private let data: HeroeAndTransformationProtocol
    private let model = NetworkModel()
    private var transformations: [HeroeAndTransformationProtocol] = []
    
    // MARK: - Init
    init(heroe: HeroeAndTransformationProtocol) {
        self.data = heroe
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        heroeName.text = data.name
        heroeImage.setImage(for: data.photo)
        heroeTextView.text = data.description
        constraintHeightButton.constant = 0.0
        transformationsButton.isHidden = true
        checkTransformationsHeroe()
    }
    
    func checkTransformationsHeroe(){
        guard let heroe = data as? Hero  else {
            return
        }
        self.model.getTransformations(for: heroe.id) {[weak self] result in
            DispatchQueue.main.async{
                switch result {
                case let .success(transformations):
                    self?.transformations.append(contentsOf: transformations)
                    self?.constraintHeightButton.constant = transformations.count > 0 ? 45.0 : 0.0
                    self?.transformationsButton.isHidden = transformations.count == 0
                case let .failure(error):
                    print("Error: \(error)")
                }
            }
        }
    }
    @IBAction func navigateToTransformations(_ sender: Any) {
        let dataProvider = TransformationsDataPRovider(data: transformations)
        let navigateToTransformations = PrincipalTableViewController( dataProvider: dataProvider)
        navigationController?.show(navigateToTransformations, sender: nil)
    }
}
