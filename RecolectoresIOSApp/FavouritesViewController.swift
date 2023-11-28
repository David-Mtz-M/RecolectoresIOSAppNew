//
//  FavouritesViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 07/11/23.
//

import UIKit
import FirebaseFirestore
import CoreLocation


class FavouritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    let database = Firestore.firestore()
    var recolecciones: Recolecciones!
    var distance: Double?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var countFavoritos: UILabel!
    @IBOutlet weak var tableViewFavourites: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
        let nib = UINib(nibName: "DemoTableViewCell", bundle: nil)
        tableViewFavourites.register(nib, forCellReuseIdentifier: "recoleccionCel")
        tableViewFavourites.delegate = self
        tableViewFavourites.dataSource = self
        tableViewFavourites.backgroundColor = UIColor.clear
        
        recolecciones = Recolecciones()
        


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
        recolecciones.loadData {
            self.tableViewFavourites.reloadData()
        }
    }
    
    private func sortedArray() -> [Recoleccion] {
        var sortedRecoleccionesArray = recolecciones.recoleccionesArray.sorted(by: { $0.getDistance(iphoneCoords: locationManager.location!) <
            $1.getDistance(iphoneCoords: locationManager.location!)})
        
        // Extract recolector data and send it to ThatCollectionViewController
        let defaults = UserDefaults.standard
        let recolectorInMemory = defaults.object(forKey: "SavedDict") as? [String: Any] ?? [String: Any]()
        let recolector = Recolector(dictionary: recolectorInMemory)
        
        
        for favorito in recolector.favoritos {
            print("Favorito ID: " + favorito)
        }
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        let systemDate = format.string(from: date)
        
        let filteredRecolecciones = sortedRecoleccionesArray.filter { recoleccion in
            return recoleccion.estado == "Iniciada" &&
            recolector.favoritos.contains(recoleccion.idUsuarioCliente) &&
            recoleccion.fechaRecoleccion == systemDate 
           
            
            // Agrega aquí tus condiciones adicionales relacionadas con el día de hoy
        }
        
        return filteredRecolecciones
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recoleccionCel", for: indexPath) as! DemoTableViewCell
        
        let recoleccionesFavoritas = sortedArray()
        
        let iphoneLocationCoords = locationManager.location
        
        let horaInicio = recoleccionesFavoritas[indexPath.row].horaRecoleccionInicio
        let horaFinal = recoleccionesFavoritas[indexPath.row].horaRecoleccionFinal
        
        cell.backgroundColor = UIColor.clear
        cell.nombreCliente?.text = recoleccionesFavoritas[indexPath.row].userInfo["nombreCompleto"] as? String
        cell.direccion?.text = recoleccionesFavoritas[indexPath.row].userInfo["direccion"] as? String
        cell.fotoRecoleccion?.image = UIImage(named: "icono-basura")
        cell.horaRecoleccion?.text = "Horario: " + horaInicio + " " + "-" + " " + horaFinal
        
        if let iphoneCoords = iphoneLocationCoords {
            let distance = recoleccionesFavoritas[indexPath.row].getDistance(iphoneCoords: iphoneCoords)
            cell.distanciaEnMinutos?.text = String(format: "%.2f metros", distance)
        } else {
            cell.distanciaEnMinutos?.text = "N/A"
        }
        
        getClienteCalificacion(recolectorID: recoleccionesFavoritas[indexPath.row].idUsuarioCliente) { clienteCalificacion in
            cell.calificacionClienteLabel.text = clienteCalificacion
            
        }
        
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
                        let clienteCantidadReseñas = document["clienteCantidadReseñas"] as? Double ?? 0.0
                        let clienteSumaReseñas = document["clienteSumaReseñas"] as? Double ?? 0.0
                        if clienteSumaReseñas <= 0.0 || clienteCantidadReseñas <= 0.0 {
                            completion("S/C")
                            return
                        }
                        let calificacionCliente = String(format: "%.1f", clienteSumaReseñas / clienteCantidadReseñas)

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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
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

