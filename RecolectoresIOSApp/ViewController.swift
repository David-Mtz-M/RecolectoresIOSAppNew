//
//  ViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 31/10/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AuthService {
    static let shared = AuthService()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    func loginUser(email: String, password: String, completion: @escaping (Recolector?, String?, Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard let self = self else { return }
            



            if let error = error {
                completion(nil, nil, error)
            } else if let user = authResult?.user {
                self.checkRecolectorDocument(uid: user.uid) { recolector, documentId, error in
                    completion(recolector, documentId, error)
  
                }
            }
        }
    }

    private func checkRecolectorDocument(uid: String, completion: @escaping (Recolector?, String?, Error?) -> Void) {
        db.collection("recolectores").document(uid).getDocument { (document, error) in
            if let error = error {
                completion(nil, nil, error)
            } else if let document = document, document.exists {
                do {
                    if let recolectorData = document.data() {
                        let recolector =  Recolector(dictionary: recolectorData)
                        let documentId = document.documentID
                        print(documentId)
                        completion(recolector, documentId, nil)
                    } else {
                        // Handle the case when recolectorData is nil
                        completion(nil, nil, NSError(domain: "AuthService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid recolector data"]))
                    }
                }
            } else {
                completion(nil, nil, NSError(domain: "AuthService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid user"]))
            }
        }
    }
}



class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var verifyLogIn: UILabel!
    
    
    
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
    
    private func updateLogInWarning(message: String?){
        verifyLogIn.text = message
    }


    @IBAction func logInButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            // Handle invalid input (e.g., show an error message)
            // save data to UserDefaults
            updateLogInWarning(message: "Ingresa tu usuario y contraseña")
            return
        }
        
        let savedData = UserDefaults.standard
        
    
        savedData.set(email, forKey: "email")

        AuthService.shared.loginUser(email: email, password: password) { [weak self] (recolector, documentId, error) in
            if let error = error {
                // Handle authentication error (e.g., show an error message)
                print("Authentication error: \(error)")
                self?.updateLogInWarning(message: "Usuario o contraseña incorrectos")
            } else if let recolector = recolector {
                // Authentication successful, retrieve Recolector data
                print("Recolector data: \(recolector)")
                
                // Combine Recolector and documentId into a single sender
                let senderData: [AnyHashable: Any] = ["recolector": recolector, "docId": documentId ?? ""]
                
                // Perform the segue with the combined sender
                self?.performSegue(withIdentifier: "moveToOptionsVC", sender: senderData)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToOptionsVC" {
            if let opcionesVC = segue.destination as? OpcionesViewController,
               let senderData = sender as? [AnyHashable: Any],
               let recolector = senderData["recolector"] as? Recolector {
                opcionesVC.recolector = recolector
                
                // Set documentID here
                opcionesVC.docId = senderData["docId"] as? String ?? ""
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

