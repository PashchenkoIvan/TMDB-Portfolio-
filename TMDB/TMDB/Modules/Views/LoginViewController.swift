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
    
    @IBOutlet weak var movieTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTextLabel.backgroundColor = UIColor.clear
        movieTextLabel.layer.borderColor = UIColor.white.cgColor
        movieTextLabel.layer.borderWidth = 3
        
        buttonStyle.layer.cornerRadius = 10
        
        let gradient = CAGradientLayer()
        gradient.frame = ImageView.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 0.1, 0.5, 0.9, 1.0]
        ImageView.layer.insertSublayer(gradient, at: 0)
        
//        let url = URL(string: "https://picsum.photos/393/852/?blur")
        let url = URL(string: "https://i.pinimg.com/564x/20/a4/23/20a4239750efa6d888960faafd1e8708.jpg")
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
