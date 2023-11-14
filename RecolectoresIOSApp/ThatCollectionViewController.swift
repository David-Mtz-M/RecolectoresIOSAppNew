//
//  ThatCollectionViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 13/11/23.
//

import UIKit
import CoreLocation

class ThatCollectionViewController: UIViewController{
    
    

    @IBOutlet weak var recollectionBgImg: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var nameBackgroundLabel: UILabel!
    @IBOutlet weak var distanceBackgroundLabel: UILabel!
    @IBOutlet weak var otherBackgroundLabel: UILabel!
    
    
    @IBOutlet weak var directionConstantTxtLabel: UILabel!
    @IBOutlet weak var phoneConstantTxtLabel: UILabel!
    @IBOutlet weak var commentsConstantTxtLabel: UILabel!
    
    
    var recoleccion: Recoleccion?
    var distance: Double?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        recollectionBgImg.image = UIImage(named: "pueblo")
        
        nameLabel.text = recoleccion?.userInfo["nombreCompleto"] as? String
        addressLabel.text = recoleccion?.userInfo["direccion"] as? String
        phoneNumberLabel.text = recoleccion?.userInfo["telefono"] as? String
        commentsLabel.text = recoleccion?.comentarios
        
        let stringDistance = String(format: "%.2f meters", distance!)
        distanceLabel.text = stringDistance

        nameBackgroundLabel.layer.cornerRadius = 10
        nameBackgroundLabel.layer.masksToBounds = true
        
        distanceBackgroundLabel.layer.cornerRadius = 10
        distanceBackgroundLabel.layer.masksToBounds = true
        
        otherBackgroundLabel.layer.cornerRadius = 10
        otherBackgroundLabel.layer.masksToBounds = true
        
        directionConstantTxtLabel.font = UIFont.boldSystemFont(ofSize: directionConstantTxtLabel.font.pointSize)
        phoneConstantTxtLabel.font = UIFont.boldSystemFont(ofSize: phoneConstantTxtLabel.font.pointSize)
        commentsConstantTxtLabel.font = UIFont.boldSystemFont(ofSize: commentsConstantTxtLabel.font.pointSize)
        
        
        configureItems()

    }
    
    private func configureItems(){
        
        var profileImg = UIImage(named: "profile")
        profileImg = profileImg?.withRenderingMode(.alwaysOriginal)
        
        var returnImg = UIImage(named: "returnIcon")
        returnImg = returnImg?.withRenderingMode(.alwaysOriginal)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImg, style: .done, target: self, action: #selector(moveToProfile))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: returnImg, style: .done, target: self, action: #selector(moveBackToRecollections))
    }

    @objc private func moveBackToRecollections() {
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "RequestsStoryboard") as! RequestsViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    @objc private func moveToProfile() {
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileStoryboard") as! ProfileViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }

}
