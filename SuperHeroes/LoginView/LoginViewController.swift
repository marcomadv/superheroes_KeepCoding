//
//  LoginViewController.swift
//  SuperHeroes
//
//  Created by Marco Muñoz on 31/8/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var wallpaper: UIImageView!
    
    private let model = NetworkModel()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = "imarcoma@gmail.com"
        passwordTextField.text = "012345"
    }
    // MARK: - Actions
    @IBAction func continueTapped(_ sender: Any) {
        
        model.login(
            user: usernameTextField.text ?? "",
            password: passwordTextField.text ?? ""
        ) {[weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.navigationToPrincipalView()
                }
            case let .failure(error):
                print("Error: \(error)")
            }
        }
    }
}
//MARK: - Navigation to PrincipalView
extension LoginViewController {
    func navigationToPrincipalView() {
        let principalTableViewController = PrincipalTableViewController( dataProvider: HeroesDataPRovider())
        self.navigationController?.setViewControllers([principalTableViewController], animated: true)
    }
}
