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
import MapKit
import CoreLocation

class RequestsViewController: UIViewController, MKMapViewDelegate {
    
    
    let map = MKMapView()
    let coordinate = CLLocation(latitude: 19.01978414393505, longitude: -98.24497640379656)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        view.addSubview(map)
        map.frame = view.bounds
        
        map.setRegion(MKCoordinateRegion(
            center: coordinate.coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 0.1,
                longitudeDelta: 0.1
                )
            ),
            animated: true)
        
        map.delegate = self
        
        addCustomPin()
    }

    
    private func addCustomPin(){
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate.coordinate
        pin.title = "Pokemon here"
        pin.subtitle = "Go and catch them all"
        map.addAnnotation(pin)
       
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        var annotationView: MKAnnotationView?
        
        return annotationView
    }
    
    private func configureItems(){
        
        var profileImg = UIImage(named: "profile")
        profileImg = profileImg?.withRenderingMode(.alwaysOriginal)
        
        var returnImg = UIImage(named: "returnIcon")
        returnImg = returnImg?.withRenderingMode(.alwaysOriginal)
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImg, style: .done, target: self, action: #selector(moveToProfile))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: returnImg, style: .done, target: self, action: #selector(moveBackToOptions))
    }
    
    @objc private func moveBackToOptions() {
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "OptionsStoryboard") as! OpcionesViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    @objc private func moveToProfile() {
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileStoryboard") as! ProfileViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    
}

