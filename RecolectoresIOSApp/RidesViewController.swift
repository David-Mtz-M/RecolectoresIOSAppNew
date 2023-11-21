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
        

        
        let recoleccionesActivas = sortedArray()
        
        let iphoneLocationCoords = locationManager.location
        
        let horaInicio = recoleccionesActivas[indexPath.row].horaRecoleccionInicio
        let horaFinal = recoleccionesActivas[indexPath.row].horaRecoleccionFinal
        
        cell.backgroundColor = UIColor.clear
        cell.nombreCliente?.text = recoleccionesActivas[indexPath.row].userInfo["nombreCompleto"] as? String
        cell.direccion?.text = recoleccionesActivas[indexPath.row].userInfo["direccion"] as? String
        cell.fotoRecoleccion?.image = UIImage(named: "icono-basura")
        cell.horaRecoleccion?.text = "Horario: " + horaInicio + " " + "-" + " " + horaFinal
        
        if let iphoneCoords = iphoneLocationCoords {
            let distance = recoleccionesActivas[indexPath.row].getDistance(iphoneCoords: iphoneCoords)
            cell.distanciaEnMinutos?.text = String(format: "%.2f meters", distance)
        } else {
            cell.distanciaEnMinutos?.text = "N/A"
        }
        
        printData()
        updateCounter()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
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
    
    
    
    
    private func configureItems(){
        
        var profileImg = UIImage(named: "profile")
        profileImg = profileImg?.withRenderingMode(.alwaysOriginal)
        
        var returnImg = UIImage(named: "returnIcon")
        returnImg = returnImg?.withRenderingMode(.alwaysOriginal)

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



