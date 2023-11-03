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
        configureItems()
        addBorderToNavigationBar()
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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }




    private func configureItems(){
        
        var profileImg = UIImage(named: "profile")
        profileImg = profileImg?.withRenderingMode(.alwaysOriginal)
        
        var logoutImg = UIImage(named: "logoutButton")
        logoutImg = logoutImg?.withRenderingMode(.alwaysOriginal)
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImg, style: .done, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoutImg, style: .done, target: self, action: nil)
    }
    
    private func addBorderToNavigationBar() {
        if let navigationBar = self.navigationController?.navigationBar {
            let borderLayer = CALayer()
            borderLayer.frame = CGRect(x: 0, y: navigationBar.frame.size.height - 1, width: navigationBar.frame.size.width, height: 1)
            borderLayer.backgroundColor = UIColor.red.cgColor // Set the border color here
            navigationBar.layer.addSublayer(borderLayer)
        }
    }



    
}

