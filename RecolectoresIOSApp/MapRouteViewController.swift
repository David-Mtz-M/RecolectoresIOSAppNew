//
//  MapRouteViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 21/11/23.
//

import Foundation
import UIKit
import MapKit


class MapRouteViewController: UIViewController {
    
    
    @IBOutlet weak var map: MKMapView!
    
    var recoleccion: Recoleccion?
    var distance: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if recoleccion != nil{
            print("recoleccion existe")
        }else{
            print("recoleccion no existe")
        }

    }
    
}
