//
//  RequestsViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 07/11/23.
//


import UIKit
import MapKit
import CoreLocation
import FirebaseAuth

// guard let userID = Auth.auth().currentUser?.uid else { return }


class RequestsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    

    // Arreglo de recolectores
    //var collectors: Recolectores!
    
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
        
        //collectors = Recolectores()
        
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
        //collectors.loadData {
          //  self.tableView.reloadData()
        //}
        
        recolecciones.loadData {
            self.tableView.reloadData()
        }
    }
    
    
    private func showPins(){
        
        var sortedRecolectoresArray = sortedArray()
        
        for sortedRecolector in sortedRecolectoresArray{
            let pin = MKPointAnnotation()
            let latitude = Double(sortedRecolector.latitud) ?? 0
            let longitude = Double(sortedRecolector.longitud) ?? 0

            pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            pin.title = sortedRecolector.userInfo["nombreCompleto"] as? String
            pin.subtitle = sortedRecolector.userInfo["direccion"] as? String
            map.addAnnotation(pin)
        }
        
    }
    
    private func sortedArray() -> [Recoleccion] {
        var sortedRecoleccionesArray = recolecciones.recoleccionesArray.sorted(by: { $0.getDistance(iphoneCoords: locationManager.location!) <
            $1.getDistance(iphoneCoords: locationManager.location!)})
        
        var count = 0
        

        
        for sortedRecolector in sortedRecoleccionesArray{
            sortedRecoleccionesArray.removeAll(where: { $0.estado != "En Proceso"})
            print(count, sortedRecolector.getDistance(iphoneCoords: locationManager.location!))
            count += 1
        }
        
        return sortedRecoleccionesArray
        
    }
    
    
    private func printRecolectores() {
        // Check if recolecciones is not nil before accessing recoleccionesArray
        for recoleccion in recolecciones.recoleccionesArray{
            print("ID")
            print(recoleccion.documentID!)
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
        return sortedArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let iphoneLocationCoords = locationManager.location

        let cell = tableView.dequeueReusableCell(withIdentifier: "recoleccionCel", for: indexPath) as! DemoTableViewCell
        

        let sortedRecoleccionesArray = sortedArray()
 
        cell.backgroundColor = UIColor.clear
        cell.nombreCliente?.text = sortedRecoleccionesArray[indexPath.row].userInfo["nombreCompleto"] as? String
        cell.direccion?.text = sortedRecoleccionesArray[indexPath.row].userInfo["direccion"] as? String
        cell.fotoRecoleccion?.image = UIImage(named: "icono-basura")

        if let iphoneCoords = iphoneLocationCoords {
            let distance = sortedRecoleccionesArray[indexPath.row].getDistance(iphoneCoords: iphoneCoords)
            cell.distanciaEnMinutos?.text = String(format: "%.2f meters", distance)
        } else {
            cell.distanciaEnMinutos?.text = "N/A"
        }
        
        showPins()
        
        printRecolectores()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecollection = recolecciones.recoleccionesArray[indexPath.row]
        let distance = recolecciones.recoleccionesArray[indexPath.row].getDistance(iphoneCoords: locationManager.location!)
        
        //  Cal the method to navigate to the next view controller
        thatCollectionViewController(with: selectedRecollection, distance: distance)

        
    }
    

    
    private func thatCollectionViewController(with recoleccion: Recoleccion?, distance: Double?){
        //let nextStoryboard = UIStoryboard(name: "ThatCollectionViewController", bundle: nil)
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "thatCollectionVC") as! ThatCollectionViewController

        // Pass the document ID to the next view controller
        nextViewController.recoleccion = recoleccion
        nextViewController.distance = distance

        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
}
