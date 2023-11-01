//
//  ViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 31/10/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    
    @IBAction func loginButton(_ sender: Any) {
        let opcionesView = OpcionesViewController()
        self.navigationController?.pushViewController(opcionesView, animated: true)
    }
    
    @IBAction func anotherLogin(_ sender: Any) {
        let opcionesView = OpcionesViewController()
        self.navigationController?.pushViewController(opcionesView, animated: true)
    }
}

