//
//  LoginViewController.swift
//  TMDB
//
//  Created by Пащенко Иван on 13.04.2024.
//

import UIKit
import Kingfisher

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var buttonStyle: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonStyle.layer.cornerRadius = 10
        
        let gradient = CAGradientLayer()
        gradient.frame = ImageView.bounds
        gradient.colors = [UIColor.systemPink.cgColor, UIColor.systemPink.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.45, 1.0]
        ImageView.layer.insertSublayer(gradient, at: 0)
        
        let url = URL(string: "https://picsum.photos/393/852/?blur")
        ImageView.kf.setImage(with: url)
        
    }
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        if let username = loginTextField.text, let password = passwordTextField.text, !username.isEmpty, !password.isEmpty {
            RequestsStaticClass.loginUser(username: username, password: password) { responce in
                print(responce)
            }
        } else {
            print("Enter login or/and password")
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToGeneralPage" {
//            if let destinationVC = segue.destination as? GeneralPageViewController {
//                // Передача данных в GeneralPageViewController, если необходимо
//            }
//        }
//    }
    
}
