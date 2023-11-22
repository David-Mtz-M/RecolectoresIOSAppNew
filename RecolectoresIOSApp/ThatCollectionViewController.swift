//
//  ThatCollectionViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 13/11/23.
//

import UIKit
import CoreLocation
import Firebase


class ThatCollectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet var continuarEncargoPopup: UIView!
    @IBOutlet var rechazarEncargoPopup: UIView!
    @IBOutlet var aceptarEncargoPopup: UIView!
    @IBOutlet var finalizarEncargoPopup: UIView!
    
    @IBOutlet weak var distanciaRestanteLabel: UILabel!
    
    
    @IBOutlet weak var recollectionBgImg: UIImageView!
    
    @IBOutlet weak var aceptarEncargoBtn: UIButton!
    @IBOutlet weak var rechazarEncargoBtn: UIButton!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var nameBackgroundLabel: UILabel!
    @IBOutlet weak var distanceBackgroundLabel: UILabel!
    @IBOutlet weak var otherBackgroundLabel: UILabel!
    
    
    @IBOutlet weak var directionConstantTxtLabel: UILabel!
    @IBOutlet weak var phoneConstantTxtLabel: UILabel!
    @IBOutlet weak var commentsConstantTxtLabel: UILabel!
    
    
    @IBOutlet weak var mapaImg: UIImageView!
    
    
    var recoleccion: Recoleccion?
    var distance: Double?
    
    
    let detalles = ["Aceite de Auto", "Aceite Usado", "Árbol", "Baterías", "Bicicletas", "Botellas", "Cartón", "Electrónicos", "Escombros", "Industriales", "Juguetes", "Libros", "Llantas", "Madera", "Medicinas", "Metal", "Orgánico", "Pallets", "Papel", "Pilas", "Plásticos", "Ropa", "Tapitas", "Tetra Pack", "Toner", "Voluminoso"]
    
    
    @IBOutlet weak var materialsTableView: UITableView!
    
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        recollectionBgImg.image = UIImage(named: "pueblo")
        
        nameLabel.text = recoleccion?.userInfo["nombreCompleto"] as? String
        addressLabel.text = recoleccion?.userInfo["direccion"] as? String
        phoneNumberLabel.text = recoleccion?.userInfo["telefono"] as? String
        commentsLabel.text = recoleccion?.comentarios
        
        let stringDistance = String(format: "%.2f meters", distance!)
        distanceLabel.text = stringDistance

        nameBackgroundLabel.layer.cornerRadius = 10
        nameBackgroundLabel.layer.masksToBounds = true
        
        distanceBackgroundLabel.layer.cornerRadius = 10
        distanceBackgroundLabel.layer.masksToBounds = true
        
        otherBackgroundLabel.layer.cornerRadius = 10
        otherBackgroundLabel.layer.masksToBounds = true
        
        directionConstantTxtLabel.font = UIFont.boldSystemFont(ofSize: directionConstantTxtLabel.font.pointSize)
        phoneConstantTxtLabel.font = UIFont.boldSystemFont(ofSize: phoneConstantTxtLabel.font.pointSize)
        commentsConstantTxtLabel.font = UIFont.boldSystemFont(ofSize: commentsConstantTxtLabel.font.pointSize)
        
        
        materialsTableView.delegate = self
        materialsTableView.dataSource = self
        materialsTableView.backgroundColor = UIColor.clear
        let nib = UINib(nibName: "MaterialTableViewCell", bundle: nil)
        materialsTableView.register(nib, forCellReuseIdentifier: "materialCell")
        
        
        configureItems()
        
        // printMaterials()
        
        
        aceptarEncargoPopup.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.85, height: self.view.bounds.height * 0.22)
        
        rechazarEncargoPopup.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.85, height: self.view.bounds.height * 0.22)
        
        continuarEncargoPopup.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.85, height: self.view.bounds.height * 0.22)
        
        finalizarEncargoPopup.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.85, height: self.view.bounds.height * 0.22)
    
        aceptarEncargoBtn.layer.cornerRadius = 10
        aceptarEncargoBtn.layer.masksToBounds = true
        
        rechazarEncargoBtn.layer.cornerRadius = 10
        rechazarEncargoBtn.layer.masksToBounds = true
        
        continuarEncargoPopup.layer.cornerRadius = 10
        continuarEncargoPopup.layer.masksToBounds = true
        
        finalizarEncargoPopup.layer.cornerRadius = 10
        finalizarEncargoPopup.layer.masksToBounds = true
        
        let tapGestureRequests = UITapGestureRecognizer(target: self, action: #selector(moveToMapDetails))
        mapaImg.isUserInteractionEnabled = true
        mapaImg.addGestureRecognizer(tapGestureRequests)
        

        configureButtons()
        
        let distanceTxt = String(format: "%.2f", distance!)
        distanciaRestanteLabel.text = "Falta recorrer \(distanceTxt) metros de distancia"


    }
    

    
    @objc func moveToMapDetails() {
        guard let mapRouteVC = storyboard?.instantiateViewController(withIdentifier: "mapRouteSB") as? MapRouteViewController else { return }
        mapRouteVC.recoleccion = recoleccion
        mapRouteVC.distance = distance
        navigationController?.pushViewController(mapRouteVC, animated: true)
    }


    
    func compareDates(phoneDate: Date, recoleccionDate: Date){
        let format = DateFormatter()
        format.timeStyle = .short
        format.dateStyle = .short
        
        if phoneDate > recoleccionDate{
            print("Ya paso la recoleccion")
            print(format.string(from: phoneDate))
            print(format.string(from: recoleccionDate))
        }else{
            print("Aun hay tiempo para la recoleccion")
            print(format.string(from: phoneDate))
            print(format.string(from: recoleccionDate))
            
        }
    }
    
    func configureButtons(){
        if recoleccion?.estado == "En Proceso"{
            aceptarEncargoBtn.setTitle("Ver distancia", for: .normal)
            mapaImg.image = UIImage(named: "mapa")
            mapaImg.clipsToBounds = true
            
            if distance! <= 200.0{
                animateIn(desiredView: finalizarEncargoPopup)
            }

        }else{
            aceptarEncargoBtn.setTitle("Aceptar Encargo", for: .normal)
            mapaImg.image = nil
        }
    }
    
    
    // Animate in a specified view
    func animateIn(desiredView: UIView){
        let backgroundView = self.view!
        
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        desiredView.center = CGPoint(x: backgroundView.center.x, y: backgroundView.center.y - 120)
        
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })
        
        // Set the corner radius after applying the transform
        desiredView.layer.cornerRadius = 30
        desiredView.layer.masksToBounds = true
      
        //desiredView.alpha = 0
    }
    
    // Animate out a specific view
    func animateOut(desiredView: UIView){
        desiredView.removeFromSuperview()
    }
    
    
    @IBAction func rechazarEncargoAction(_ sender: Any) {

        animateIn(desiredView: rechazarEncargoPopup)
        
    }
    
    
    @IBAction func aceptaEncargoAction(_ sender: Any) {
        if aceptarEncargoBtn.title(for: .normal) == "Ver distancia"{
           if distance! <= 200{
               animateIn(desiredView: finalizarEncargoPopup)
           }else{
               animateIn(desiredView: continuarEncargoPopup)
           }
        }else{
            animateIn(desiredView: aceptarEncargoPopup)
        }
    }
    
    
    @IBAction func finalizarEncargoActionTrue(_ sender: Any) {
    }
    
    @IBAction func finalizarEncargoActionFalse(_ sender: Any) {
        animateOut(desiredView: finalizarEncargoPopup)
    }
    
    @IBAction func cancelActionAceptarPopup(_ sender: Any) {
        animateOut(desiredView: aceptarEncargoPopup)
    }
    
    
    @IBAction func cancelActionRechazarPopup(_ sender: Any) {
        animateOut(desiredView: rechazarEncargoPopup)
    }
    
    @IBAction func continuarActionPopup(_ sender: Any) {
        animateOut(desiredView: continuarEncargoPopup)
        
    }
    
    @IBAction func confirmarRecoleccion(_ sender: Any) {
        
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "ridesVC") as! RidesViewController

        // Pass the document ID to the next view controller
        nextViewController.distance = distance


        
        
        // Guardar ID de la recoleccion en cuestion
        let  recoleccionDocumentID = recoleccion?.documentID
        
        // Acceder a atributos del recolector asi como a su recolectorID
        let defaults = UserDefaults.standard
        let recolectorInMemory = defaults.object(forKey: "SavedDict") as? [String: Any] ?? [String: Any]()
        // Atributos
        let apellidos = recolectorInMemory["apellidos"] as! String
        let cantidad_reseñas = recolectorInMemory["cantidad_reseñas"] as! Int
        let fotoUrl = recolectorInMemory["fotoUrl"] as! String
        let recolectorID = defaults.string(forKey: "documentID")
        let nombre = recolectorInMemory["nombre"] as! String
        let suma_reseñas = recolectorInMemory["suma_reseñas"] as! Int
        let telefono = recolectorInMemory["telefono"] as! String
        
        print("Recoleccion document ID: ")
        print(recoleccionDocumentID!)
        
        // Hacer el write en Firebase

        db.collection("recolecciones").document(recoleccionDocumentID!).updateData([
            "recolector.apellidos": apellidos,
            "recolector.cantidad_reseñas": cantidad_reseñas  ,
            "recolector.fotoUrl":  fotoUrl ,
            "recolector.id": recolectorID!  ,
            "recolector.nombre":  nombre ,
            "recolector.suma_reseñas":  suma_reseñas ,
            "recolector.telefono": telefono,
            "estado": "En Proceso"
        ]){ err in
            if let err = err {
              print("Error updating document: \(err)")
            } else {
              print("Document successfully updated")
            }
            
        }
        animateOut(desiredView: aceptarEncargoPopup)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recoleccion!.materiales.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "materialCell", for: indexPath) as! MaterialTableViewCell
        let materialesArr = getMaterialsArray()
        let material = materialesArr[indexPath.row]
        
        cell.fotoMaterial.image = UIImage(named: material)
        
        cell.backgroundColor = UIColor.clear
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    private func getMaterialsArray() -> [String] {
        guard let materiales = recoleccion?.materiales else {
            return []
        }
        
        var materialsArray: [String] = []

        for (_, materialInfo) in materiales {
            if let nombre = materialInfo["nombre"] as? String {
                //print("Material Nombre: \(nombre)")
                materialsArray.append(nombre)
            }
        }
        print("Materials Array:  \(materialsArray.count)")
        return materialsArray
    }
    
    private func printMaterials(){
        let materials = getMaterialsArray()
        
        for material in materials{
            print(material)
        }
    }


    
    private func configureItems(){
        
        var profileImg = UIImage(named: "profile")
        profileImg = profileImg?.withRenderingMode(.alwaysOriginal)
        
        var returnImg = UIImage(named: "returnIcon")
        returnImg = returnImg?.withRenderingMode(.alwaysOriginal)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImg, style: .done, target: self, action: #selector(moveToProfile))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: returnImg, style: .done, target: self, action: #selector(moveBackToRecollections))
    }

    @objc private func moveBackToRecollections() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func moveToProfile() {
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileStoryboard") as! ProfileViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }

}
