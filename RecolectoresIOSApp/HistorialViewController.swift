//
//  HistorialViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 24/11/23.
//

import Foundation
import CoreLocation
import FirebaseFirestore
import UIKit



class HistorialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var historialTableView: UITableView!
    
    
    @IBOutlet weak var countHistorial: UILabel!
    
    
    // Arreglo de recolecciones
    var recolecciones: Recolecciones!
    
    let locationManager = CLLocationManager()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
        
        let nib = UINib(nibName: "DemoTableViewCell", bundle: nil)
        historialTableView.register(nib, forCellReuseIdentifier: "recoleccionCel")
        historialTableView.delegate = self
        historialTableView.dataSource = self
        historialTableView.backgroundColor = UIColor.clear
        
        recolecciones = Recolecciones()
        


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // cargar arreglo de recolecciones
        recolecciones.loadData {
            self.historialTableView.reloadData()
        }
    }
            

    
    private func printRecoleccionRecolector(){
        for recolector in recolecciones.recoleccionesArray {
            if let recolectorID = recolector.recolector["id"] as? String? {
                // El recolectorID no es nil, puedes usarlo de manera segura
                print("ID recolector de la recolección")
                print(recolectorID!)
            } else {
                // El recolectorID es nil o no es un String
                print("ID recolector de la recolección es nil o no es un String")
            }
        }
    }

    
    private func sortedArray() -> [Recoleccion] {
        var sortedRecoleccionesArray = recolecciones.recoleccionesArray.sorted(by: { $0.getDistance(iphoneCoords: locationManager.location!) <
            $1.getDistance(iphoneCoords: locationManager.location!)})
        

        
        // recolectorData.set(docId, forKey: "documentID")
        let recolectorData = UserDefaults.standard
        let recolectorID = recolectorData.string(forKey: "documentID")
        
        //print("ID del recolector")
        //print(recolectorID!)
        
        
        for _ in sortedRecoleccionesArray{
            // Elimina recolecciones que no han sido completadas por el recolector actual
            sortedRecoleccionesArray.removeAll(where: { $0.estado != "Completada"})
            //Elimina recolecciones que no le corresponden al recolector actual
           // sortedRecoleccionesArray.removeAll(where: { $0.recolector["id"] as? String? != recolectorID! })

        }
        
        let filtered = sortedRecoleccionesArray.filter { recoleccion in
            if let recolectorId = recoleccion.recolector["id"] as? String? {
                return recolectorId != recolectorID
            } else {
                return true // Otra lógica si no se puede obtener el ID del recolector
            }
        }
        
        
        return filtered
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("aQUI EMPIEZA")
        //getClienteCalificacion()
        
        

        
        let iphoneLocationCoords = locationManager.location

        let cell = tableView.dequeueReusableCell(withIdentifier: "recoleccionCel", for: indexPath) as! DemoTableViewCell
        

        let sortedRecoleccionesArray = sortedArray()
        
        let horaInicio = sortedRecoleccionesArray[indexPath.row].horaRecoleccionInicio
        let horaFinal = sortedRecoleccionesArray[indexPath.row].horaRecoleccionFinal
        //let clienteID = sortedRecoleccionesArray[indexPath.row].idUsuarioCliente

        

        
 
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

        
        //printRecolecciones()
        //printSortedRecolecciones()
        
        //printRecolectores()
        
        //printRecoleccionRecolector()
        let count = String(sortedArray().count)
        countHistorial.text = "Has completado " + count + " recolecciones"

        
        
        return cell
    }
    
    private func getClienteCalificacion(recolectorID: String, completion: @escaping (String) -> Void) {
        var clienteCalificacion = "S/C"

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
