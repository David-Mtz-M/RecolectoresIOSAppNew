//
//  RidesViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 07/11/23.
//


import UIKit
import FirebaseFirestore
import CoreLocation



class RidesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
   
    let database = Firestore.firestore()
    var recolecciones: Recolecciones!
    var distance: Double?
    let locationManager = CLLocationManager()
    
    
    
    @IBOutlet weak var contadorRecoleccionesActivasLabel: UILabel!
    
    
    @IBOutlet weak var ridesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
        let nib = UINib(nibName: "DemoTableViewCell", bundle: nil)
        ridesTableView.register(nib, forCellReuseIdentifier: "recoleccionCel")
        ridesTableView.delegate = self
        ridesTableView.dataSource = self
        ridesTableView.backgroundColor = UIColor.clear
        
        recolecciones = Recolecciones()
        


        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //collectors.loadData {
          //  self.tableView.reloadData()
        //}
        
        recolecciones.loadData {
            self.ridesTableView.reloadData()
        }
    }
    
    private func printData(){
        for recoleccion in recolecciones.recoleccionesArray{
            print(recoleccion.documentID!)
        }
    }
    
    private func updateCounter(){
        let contRecoleccionesActivas = String(sortedArray().count)
        if sortedArray().count <= 1{
            contadorRecoleccionesActivasLabel.text = "Tienes " + contRecoleccionesActivas + " viaje"
        }else{
            contadorRecoleccionesActivasLabel.text = "Tienes " + contRecoleccionesActivas + " viajes"
        }
        
    }
    
    private func printRecoleccionClienteID() {
        print("Recoleccion Cliente ID")
        
        // Iterate through each 'recoleccion' in the 'recoleccionesArray'
        for recoleccion in recolecciones.recoleccionesArray {
            let recoleccionClienteID = recoleccion.idUsuarioCliente
            
            // Directly print the client ID without checking for nil
            print("Cliente ID: \(recoleccionClienteID)")
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
            sortedRecoleccionesArray.removeAll(where: { $0.estado != "En Proceso"})
            // Remueve aquellas recolecciones que no coinciden con el día de hoy
            sortedRecoleccionesArray.removeAll(where: { $0.fechaRecoleccion != systemDate})
            //print(count, sortedRecolector.getDistance(iphoneCoords: locationManager.location!))
            //count += 1
        }
        
        
        return sortedRecoleccionesArray
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recoleccionCel", for: indexPath) as! DemoTableViewCell
        

        
        let sortedRecoleccionesArray = sortedArray()
        
        let iphoneLocationCoords = locationManager.location
        
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
            

        }
        
        //printData()
        updateCounter()
        printRecoleccionClienteID()
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sortedRecoleccionesArray = sortedArray()
        let selectedRecollection = sortedRecoleccionesArray[indexPath.row]
        
        let distance = selectedRecollection.getDistance(iphoneCoords: locationManager.location!)
        
        // Extract recolector data and send it to ThatCollectionViewController
        let defaults = UserDefaults.standard
        let recolectorInMemory = defaults.object(forKey: "SavedDict") as? [String: Any] ?? [String: Any]()
        let recolector = Recolector(dictionary: recolectorInMemory)


        //  Cal the method to navigate to the next view controller
        thatCollectionViewController(with: selectedRecollection, distance: distance, recolector: recolector)
    }
    

    private func thatCollectionViewController(with recoleccion: Recoleccion?, distance: Double?, recolector: Recolector?){
        //let nextStoryboard = UIStoryboard(name: "ThatCollectionViewController", bundle: nil)
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "thatCollectionVC") as! ThatCollectionViewController

        // Pass the document ID to the next view controller
        nextViewController.recoleccion = recoleccion
        nextViewController.distance = distance
        nextViewController.recolector = recolector

        self.navigationController?.pushViewController(nextViewController, animated: true)
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



