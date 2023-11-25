//
//  HistorialViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 24/11/23.
//

import Foundation
import CoreLocation
import UIKit



class HistorialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var historialTableView: UITableView!
    
    
    @IBOutlet weak var countHistorial: UILabel!
    
    
    // Arreglo de recolecciones
    var recolecciones: Recolecciones!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        print("ID del recolector")
        print(recolectorID!)
        
        
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
            cell.distanciaEnMinutos?.text = String(format: "%.2f meters", distance)
        } else {
            cell.distanciaEnMinutos?.text = "N/A"
        }
        
        //printRecolecciones()
        //printSortedRecolecciones()
        
        //printRecolectores()
        
        //printRecoleccionRecolector()
        let count = String(sortedArray().count)
        countHistorial.text = "Has completado " + count + " recolecciones"
        
        return cell
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
        100
    }
}
