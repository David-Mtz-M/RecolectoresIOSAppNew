//
//  OpcionesViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 01/11/23.
//


import UIKit

class OpcionesViewController: UIViewController {
    
    var recolector: Recolector!
    var email: String!
    var password: String!
    
    
    @IBOutlet weak var requestsOption: UIImageView!
    
    @IBOutlet weak var ridesOption: UIImageView!
    
    @IBOutlet weak var favouriteOption: UIImageView!
    
    @IBOutlet weak var profileOption: UIImageView!
    
    
    @IBOutlet weak var detailsOption: UIImageView!
    
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
        // Configurar imagen para que al hacer tap mande a otro storyboard

        let tapGestureRequests = UITapGestureRecognizer(target: self, action: #selector(moveToRequestsSB))
        requestsOption.isUserInteractionEnabled = true
        requestsOption.addGestureRecognizer(tapGestureRequests)
        
        let tapGestureRides = UITapGestureRecognizer(target: self, action: #selector(moveToRidesSB))
        ridesOption.isUserInteractionEnabled = true
        ridesOption.addGestureRecognizer(tapGestureRides)
        
        let tapGestureProfile = UITapGestureRecognizer(target: self, action: #selector(moveToProfileSB))
        profileOption.isUserInteractionEnabled = true
        profileOption.addGestureRecognizer(tapGestureProfile)
        
        let tapGestureDetails = UITapGestureRecognizer(target: self, action: #selector(moveToDetailsSB))
        detailsOption.isUserInteractionEnabled = true
        detailsOption.addGestureRecognizer(tapGestureDetails)
        
        let tapGestureFavourites = UITapGestureRecognizer(target: self, action: #selector(moveToFavouritesSB))
        favouriteOption.isUserInteractionEnabled = true
        favouriteOption.addGestureRecognizer(tapGestureFavourites)
        
        welcomeLabel.text = "Bienvenido" + " " + AuthService.shared.currentRecolector!.nombre
        
        
        printRecolectorData()
    }
    
    private func printRecolectorData(){

        print(AuthService.shared.currentRecolector!.nombre)
        print(AuthService.shared.currentRecolector!.apellidos)
        print(AuthService.shared.currentRecolector!.usuario)
        print(AuthService.shared.currentRecolector!.telefono)

    }

    
    @objc func moveToRequestsSB() {
        performSegue(withIdentifier: "moveToRequestsSB", sender: self)
    }
    
    @objc func moveToRidesSB() {
        performSegue(withIdentifier: "moveToRidesSB", sender: self)
    }
    
    @objc func moveToProfileSB() {
        performSegue(withIdentifier: "moveToProfileSB", sender: self)
    }
    
    @objc func moveToDetailsSB() {
        performSegue(withIdentifier: "moveToDetailsSB", sender: self)
    }
    
    @objc func moveToFavouritesSB() {
        performSegue(withIdentifier: "moveToFavouritesSB", sender: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc private func moveBackToBeginning() {
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "logInStoryboard") as! ViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    @objc private func moveToProfile() {
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileStoryboard") as! ProfileViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    


    
    private func configureItems(){
        
        var profileImg = UIImage(named: "profile")
        profileImg = profileImg?.withRenderingMode(.alwaysOriginal)
        
        var logoutImg = UIImage(named: "logoutButton")
        logoutImg = logoutImg?.withRenderingMode(.alwaysOriginal)
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImg, style: .done, target: self, action: #selector(moveToProfile))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoutImg, style: .done, target: self, action: #selector(moveBackToBeginning))
    }
    


    
}

