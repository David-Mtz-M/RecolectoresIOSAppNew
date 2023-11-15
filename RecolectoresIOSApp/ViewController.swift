//
//  ViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 31/10/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AuthService{
    static let shared = AuthService()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func loginUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        // Authenticate the user with email and password
        auth.signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(error)
            } else if let user = authResult?.user {
                // Check if Recolector document exists in Firestore for the given UID
                self.checkRecolectorDocument(uid: user.uid, completion: completion)
            }
        }
    }
    
    private func checkRecolectorDocument(uid: String, completion: @escaping (Error?) -> Void) {
        // Check if Recolector document exists in Firestore for the given UID
        db.collection("recolectores").document(uid).getDocument { (document, error) in
            if let error = error {
                completion(error)
            } else if document?.exists == true {
                // Recolector document exists, user can log in
                completion(nil)
            } else {
                // Recolector document doesn't exist, user cannot log in
                completion(NSError(domain: "AuthService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid user"]))
            }
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        addBorderToNavigationBar()
        // Do any additional setup after loading the view.
        emailTextField.clipsToBounds = true
        emailTextField.layer.cornerRadius = 10.0
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor.red.cgColor
        
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 10.0
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor.red.cgColor
        
    }


    @IBAction func logInButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            // Handle invalid input (e.g., show an error message)
            return
        }

        AuthService.shared.loginUser(email: email, password: password) { [weak self] (error) in
            if let error = error {
                // Handle authentication error (e.g., show an error message)
                print("Authentication error: \(error.localizedDescription)")
            } else {
                // Authentication successful, navigate to the next screen or perform other actions
                print("Authentication successful")
                // Example: navigate to a home screen
                self?.performSegue(withIdentifier: "moveToOptionsVC", sender: self)
            }
        }
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

