//
//  OpcionesViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 01/11/23.
//


import UIKit

class OpcionesViewController: UIViewController {
    
    var recolector: Recolector!
    var docId: String!
    var email: String!
    var password: String!
    

    

    
    
    @IBOutlet weak var pruebaImg: UIImageView!
    
    
    @IBOutlet weak var requestsOption: UIImageView!
    @IBOutlet weak var ridesOption: UIImageView!
    @IBOutlet weak var favouriteOption: UIImageView!
    @IBOutlet weak var profileOption: UIImageView!
    @IBOutlet weak var detailsOption: UIImageView!
    
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
        
        
        let recolectorData = UserDefaults.standard
        
        if docId != nil{
            recolectorData.set(docId, forKey: "documentID")
            recolectorData.set(recolector.dictionary, forKey: "SavedDict")
        }

        
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
        
        let recolectorInMemory = recolectorData.object(forKey: "SavedDict") as? [String: Any] ?? [String: Any]()
        let nombre = recolectorInMemory["nombre"] as! String
        let fotoUrl = recolectorInMemory["fotoUrl"] as! String
        
        welcomeLabel.text = "Bienvenido" + " " + nombre
        
        let imgUrl = URL(string: fotoUrl)


        
        Recolector.loadProfilePicture(imgUrl: imgUrl!, imgView: pruebaImg)
            
        
        showToast(message: "Recolección añadida a favoritos", font: .systemFont(ofSize: 14))
    }
    
    private func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height-100, width: 250, height: 40))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        // Use DispatchQueue to delay the removal of the toastLabel
       // DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            //toastLabel.removeFromSuperview()
        //}
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

