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
import FirebaseFirestore

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
        
        let fechaActual = Date()
        let format = DateFormatter()
        format.timeStyle = .short
        format.dateStyle = .short
        print("Fecha actual formatted: ")
        print(format.string(from: fechaActual))
        print("Fecha actual")
        print(fechaActual)
        

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
        
        let sortedRecolectoresArray = sortedArray()
        
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
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        
        let systemDate = format.string(from: date)
        
        
        for _ in sortedRecoleccionesArray{
            sortedRecoleccionesArray.removeAll(where: { $0.estado != "Iniciada"})
            // Remueve aquellas recolecciones que no coinciden con el día de hoy
            sortedRecoleccionesArray.removeAll(where: { $0.fechaRecoleccion != systemDate})
            //print(count, sortedRecolector.getDistance(iphoneCoords: locationManager.location!))
            //count += 1
        }
        
        
        return sortedRecoleccionesArray
        
    }
    
    
    private func printRecolecciones(){
        let sortedRecolecciones = sortedArray()
        
        for recoleccion in recolecciones.recoleccionesArray {
            print("Recoleccion normal")
            print(recoleccion.estado)
            print(recoleccion.documentID!)
            print(recoleccion.fechaRecoleccion)
            print("\n")
        }
    }
    
    private func printSortedRecolecciones(){
        let sortedRecolecciones = sortedArray()
        
        for sortedRecoleccion in sortedRecolecciones {
            print("Sorted Recoleccion")
            print(sortedRecoleccion.estado)
            print(sortedRecoleccion.documentID!)
            print(sortedRecoleccion.fechaRecoleccion)
        }
    }
    
    private func printRecolectores() {
        // Check if recolecciones is not nil before accessing recoleccionesArray
        for recoleccion in recolecciones.recoleccionesArray{
            print("DIA, HORA INICIO, HORA FINAL")
            print(recoleccion.fechaRecoleccion)
            print(recoleccion.horaRecoleccionInicio)
            print(recoleccion.horaRecoleccionFinal)
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
        
        print("Iphone coordinates")
        print(iphoneCoords)
    }
    

    

    
    private func configureItems() {
        let defaults = UserDefaults.standard
        let recolectorInMemory = defaults.object(forKey: "SavedDict") as? [String: Any] ?? [String: Any]()
        let recolector = Recolector(dictionary: recolectorInMemory)
        let imgUrl = URL(string: recolector.fotoUrl)

        // Set a placeholder image
        let placeholderImage = UIImage(named: "placeholder") ?? UIImage()

        if let url = imgUrl {
            // Use the placeholder image initially
            self.updateNavigationBarItems(with: placeholderImage)

            DispatchQueue.global().async {
                do {
                    let imageData = try Data(contentsOf: url, options: .mappedIfSafe)
                    let bgImage = UIImage(data: imageData)

                    // Update the UI on the main queue
                    DispatchQueue.main.async {
                        if let bgImage = bgImage {
                            // Use bgImage as needed
                            self.updateNavigationBarItems(with: bgImage)
                        }
                    }
                } catch {
                    // Handle the error
                    print("Error downloading image: \(error.localizedDescription)")
                }
            }
        } else {
            // Handle invalid URL
            print("Invalid URL")
        }
    }


    private func updateNavigationBarItems(with image: UIImage) {
        // Resize the image to 40x40 pixels
        let resizedImage = image.resizedTo(width: 30, height: 30)

        let profileImg = resizedImage.withRenderingMode(.alwaysOriginal)
        let returnImg = UIImage(named: "returnIcon")?.withRenderingMode(.alwaysOriginal)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImg, style: .done, target: self, action: #selector(moveToProfile))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: returnImg, style: .done, target: self, action: #selector(moveBackToOptions))
    }


    
    @objc private func moveBackToOptions() {
        self.navigationController?.popViewController(animated: true)
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
        
        let horaInicio = sortedRecoleccionesArray[indexPath.row].horaRecoleccionInicio
        let horaFinal = sortedRecoleccionesArray[indexPath.row].horaRecoleccionFinal
 
        cell.backgroundColor = UIColor.clear
        cell.nombreCliente?.text = sortedRecoleccionesArray[indexPath.row].userInfo["nombreCompleto"] as? String
        cell.direccion?.text = sortedRecoleccionesArray[indexPath.row].userInfo["direccion"] as? String
        cell.fotoRecoleccion?.image = UIImage(named: "icono-basura")
        cell.horaRecoleccion?.text = "Horario: " + horaInicio + " " + "-" + " " + horaFinal

        if let iphoneCoords = iphoneLocationCoords {
            let distance = sortedRecoleccionesArray[indexPath.row].getDistance(iphoneCoords: iphoneCoords)
            cell.distanciaEnMinutos?.text = String(format: "%.2f metros", distance)
        } else {
            cell.distanciaEnMinutos?.text = "N/A"
        }
        
        getClienteCalificacion(recolectorID: sortedRecoleccionesArray[indexPath.row].idUsuarioCliente) { clienteCalificacion in
            cell.calificacionClienteLabel.text = clienteCalificacion
            
            print("cliente calificacion")
            print(clienteCalificacion)
        }
        
        
        showPins()
        //printRecolecciones()
        //printSortedRecolecciones()
        
        //printRecolectores()
        
        return cell
    }
    private func getClienteCalificacion(recolectorID: String, completion: @escaping (String) -> Void) {
        var clienteCalificacion = "S/C"
        
        let db = Firestore.firestore()

        db.collection("usuarios").whereField("clienteID", isEqualTo: recolectorID)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(clienteCalificacion)
                } else {
                    for document in querySnapshot!.documents {
                        print("FuncionaaaaAAAAA")
                        let clienteCantidadReseñas = document["clienteCantidadReseñas"] as? Double ?? 0.0
                        let clienteSumaReseñas = document["clienteSumaReseñas"] as? Double ?? 0.0
                        if clienteSumaReseñas <= 0.0 || clienteCantidadReseñas <= 0.0 {
                            completion("S/C")
                            return
                        }
                        let calificacionCliente = String(format: "%.1f", clienteSumaReseñas / clienteCantidadReseñas)
                        print("datos cliente")
                        print(clienteSumaReseñas)
                        print(calificacionCliente)
                        print("\(calificacionCliente)")
                        clienteCalificacion = calificacionCliente
                    }
                    completion(clienteCalificacion)
                }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sortedRecoleccionesArray = sortedArray()
        let selectedRecollection = sortedRecoleccionesArray[indexPath.row]
        
        let distance = selectedRecollection.getDistance(iphoneCoords: locationManager.location!)


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
        120
    }
    
    
}
