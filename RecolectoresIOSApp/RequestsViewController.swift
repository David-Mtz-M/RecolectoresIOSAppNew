//
//  RequestsViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 07/11/23.
//

import UIKit


//
//  ViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 31/10/23.
//

import UIKit

class RequestsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        
        var profileImg = UIImage(named: "profile")
        profileImg = profileImg?.withRenderingMode(.alwaysOriginal)
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImg, style: .done, target: self, action: nil)
    }
    
    
}

