//
//  ThatCollectionViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 13/11/23.
//

import UIKit

class ThatCollectionViewController: UIViewController{
    
    

    @IBOutlet weak var recollectionBgImg: UIImageView!
    
    var recoleccion: Recoleccion?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recollectionBgImg.image = UIImage(named: "house")
        
        
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
