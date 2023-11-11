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


class RequestsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    

    // Arreglo de recolectores
    var collectors: Recolectores!
    
    // Arreglo de recolecciones
    var recolecciones: Recolecciones!
    
    var location: CLLocation!
    
    
    let coordinate = CLLocation(latitude: 19.01978414393505, longitude: -98.24497640379656)
    
    
    // let distance = coordinate.distance(from: <#T##CLLocation#>)
    
    let locationManager = CLLocationManager()
    
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
            animated: true )
        
        self.map.delegate = self
        map.showsUserLocation = true
        
        addCustomPin()
        
        collectors = Recolectores()
        
        recolecciones = Recolecciones()
        
        let nib = UINib(nibName: "DemoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "recoleccionCel")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectors.loadData {
            self.tableView.reloadData()
        }
        
        recolecciones.loadData {
            self.tableView.reloadData()
        }
    }
    
    
    private func calculateDistance(){
        
        for recolector in recolecciones.recoleccionesArray{
            print("userLocation DISTANCIAAAA")
            let userLocation = locationManager.location
            print(userLocation ?? "")
        }
    }
    
    
    
    private func showPins(){
        
        for recolector in recolecciones.recoleccionesArray{
            let pin = MKPointAnnotation()
            let latitude = Double(recolector.latitud) ?? 0
            let longitude = Double(recolector.longitud) ?? 0

            pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            pin.title = recolector.userInfo["nombreCompleto"] as? String
            pin.subtitle = recolector.userInfo["direccion"] as? String
            map.addAnnotation(pin)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        
        // get latitud, longitude
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let userPin = MKPointAnnotation()
        let iphoneCoords = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        userPin.coordinate = iphoneCoords
        userPin.title = "Ubicacion de usuario"
        userPin.subtitle = "Me encuentro aqui!"
        map.addAnnotation(userPin)
        
        
        print("EEEEEEEE")
        print(iphoneCoords)
        
        
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
        return recolecciones.recoleccionesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let iphoneLocationCoords = locationManager.location

        let cell = tableView.dequeueReusableCell(withIdentifier: "recoleccionCel", for: indexPath) as! DemoTableViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.nombreCliente?.text = recolecciones.recoleccionesArray[indexPath.row].userInfo["nombreCompleto"] as? String
        cell.direccion?.text = recolecciones.recoleccionesArray[indexPath.row].userInfo["direccion"] as? String
        cell.fotoRecoleccion?.image = UIImage(named: "puebla-recicla-icono")

        if let iphoneCoords = iphoneLocationCoords {
            let distance = recolecciones.recoleccionesArray[indexPath.row].getDistance(iphoneCoords: iphoneCoords)
            cell.distanciaEnMinutos?.text = String(format: "%.2f meters", distance)
        } else {
            cell.distanciaEnMinutos?.text = "N/A"
        }
        
        showPins()

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
}
