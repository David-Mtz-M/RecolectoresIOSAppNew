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

class RequestsViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    

    
    var collectors: Recolectores!
    

    
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
        
        collectors = Recolectores()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectors.loadData {
            self.tableView.reloadData()
        }
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


extension RequestsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectors.recolectoresArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        cell.nombre?.text = collectors.recolectoresArray[indexPath.row].usuario
        cell.imagenCasa?.image = UIImage(named: "house")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
}

