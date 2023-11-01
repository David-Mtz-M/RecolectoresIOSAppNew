//
//  ViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 31/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userTextField.clipsToBounds = true
        userTextField.layer.cornerRadius = 10.0
        userTextField.layer.borderWidth = 1.0
        userTextField.layer.borderColor = UIColor.red.cgColor
        
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 10.0
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor.red.cgColor
    }

    @IBAction func logInButton(_ sender: Any) {
        performSegue(withIdentifier: "goToOpcionesStoryboard", sender: self)
    }
    
    
}

