//
//  RequestsViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 07/11/23.
//


import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore

class RequestsViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var recoleccionesTable: UITableView!
    
    private let dbReference = Firestore.firestore().collection("recolectores")
    private (set) var recolectores = [Recolector]()
    

    
    
    struct Sunset {
        let title: String
        let imageName: String
    }
    
    let data: [Sunset] = [
        Sunset(title: "1", imageName: "house"),
        Sunset(title: "2", imageName: "house"),
        Sunset(title: "3", imageName: "house"),
        Sunset(title: "4", imageName: "house"),
    ]
    
    let coordinate = CLLocation(latitude: 19.01978414393505, longitude: -98.24497640379656)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
        self.map.setRegion(MKCoordinateRegion(
            center: coordinate.coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 0.1,
                longitudeDelta: 0.1
                )
            ),
            animated: true)
        
        self.map.delegate = self
        
        addCustomPin()
        
        
        recoleccionesTable.dataSource = self
        recoleccionesTable.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint(recolectores.count)
        return recolectores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recolector = recolectores[indexPath.row]
        
        let cell = recoleccionesTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        cell.clientName.text = recolector.apellidos
        cell.iconImageView.image = UIImage(named: "house")
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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

