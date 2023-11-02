//
//  OpcionesViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 01/11/23.
//


import UIKit

class OpcionesViewController: UIViewController {
    
    @IBOutlet weak var optionsImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //options
        optionsImgView.layer.shadowColor = UIColor.black.cgColor
        optionsImgView.layer.shadowOpacity = 0.4
        optionsImgView.layer.shadowOffset = CGSize(width: 1, height: 1)
        optionsImgView.layer.shadowRadius = 2
        optionsImgView.layer.masksToBounds = false
    }
    
}

