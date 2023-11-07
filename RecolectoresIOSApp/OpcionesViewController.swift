//
//  OpcionesViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 01/11/23.
//


import UIKit

class OpcionesViewController: UIViewController {
    

    @IBOutlet weak var requestsOption: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
        // Configurar imagen para que al hacer tap mande a otro storyboard

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveToRequestsSB))
        requestsOption.isUserInteractionEnabled = true
        requestsOption.addGestureRecognizer(tapGesture)

    }
    
    @objc func moveToRequestsSB() {
        performSegue(withIdentifier: "moveToRequestsSB", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc private func moveBackToBeginning() {
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "logInStoryboard") as! ViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    


    
    private func configureItems(){
        
        var profileImg = UIImage(named: "profile")
        profileImg = profileImg?.withRenderingMode(.alwaysOriginal)
        
        var logoutImg = UIImage(named: "logoutButton")
        logoutImg = logoutImg?.withRenderingMode(.alwaysOriginal)
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImg, style: .done, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoutImg, style: .done, target: self, action: #selector(moveBackToBeginning))
    }
    


    
}

