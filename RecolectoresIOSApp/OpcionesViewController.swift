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
        
        //Oculta el backButton de IOS para salir del logout
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem = nil
        
        
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
        
        welcomeLabel.text = "Bienvenido" + " " + nombre
        




            
        
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
    
    private func configureItems() {
        let defaults = UserDefaults.standard
        let recolectorInMemory = defaults.object(forKey: "SavedDict") as? [String: Any] ?? [String: Any]()
        let recolector = Recolector(dictionary: recolectorInMemory)
        let imgUrl = URL(string: recolector.fotoUrl)

        // Set a placeholder image
        let placeholderImage = UIImage(named: "placeholder") ?? UIImage()

        if let url = imgUrl {
            // Use the placeholder image initially
            self.updateNavigationBarItems(with: placeholderImage)

            DispatchQueue.global().async {
                do {
                    let imageData = try Data(contentsOf: url, options: .mappedIfSafe)
                    let bgImage = UIImage(data: imageData)

                    // Update the UI on the main queue
                    DispatchQueue.main.async {
                        if let bgImage = bgImage {
                            // Use bgImage as needed
                            self.updateNavigationBarItems(with: bgImage)
                        }
                    }
                } catch {
                    // Handle the error
                    print("Error downloading image: \(error.localizedDescription)")
                }
            }
        } else {
            // Handle invalid URL
            print("Invalid URL")
        }
    }


    private func updateNavigationBarItems(with image: UIImage) {
        // Resize the image to 40x40 pixels
        let resizedImage = image.resizedTo(width: 30, height: 30)

        let profileImg = resizedImage.withRenderingMode(.alwaysOriginal)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImg, style: .done, target: self, action: #selector(moveToProfile))
    }


    
    @objc private func moveBackToOptions() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func moveToProfile() {
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileStoryboard") as! ProfileViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    


    
}

extension UIImage {
    func resizedTo(width: CGFloat, height: CGFloat) -> UIImage {
        let newSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}

