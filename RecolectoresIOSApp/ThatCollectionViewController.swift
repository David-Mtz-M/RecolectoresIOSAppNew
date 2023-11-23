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
    @IBOutlet var ratingPopup: UIView!
    
    
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
    
    @IBOutlet var starButtonCollection: [UIButton]!
    

    
    var recoleccion: Recoleccion?
    var distance: Double?
    var recolector: Recolector?
    
    var ratingOficial: Int?
    

    
    var rating = 0{
        didSet{
            for starButton in starButtonCollection{
                let imageName = (starButton.tag < rating ? "star.fill" : "star")
                starButton.setImage(UIImage(systemName: imageName), for: .normal)
                starButton.tintColor = (starButton.tag < rating ? .systemRed : .darkText)
            }
            print(">> new rating \(rating)")
            ratingOficial = rating
            recolector?.reseñaActual = rating
            print("Reseña actual \(ratingOficial ?? 0)")
        }
    }
    
   
    
    
    
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
        
        ratingPopup.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.85, height: self.view.bounds.height * 0.22)
    
        aceptarEncargoBtn.layer.cornerRadius = 10
        aceptarEncargoBtn.layer.masksToBounds = true
        
        rechazarEncargoBtn.layer.cornerRadius = 10
        rechazarEncargoBtn.layer.masksToBounds = true
        
        continuarEncargoPopup.layer.cornerRadius = 10
        continuarEncargoPopup.layer.masksToBounds = true
        
        finalizarEncargoPopup.layer.cornerRadius = 10
        finalizarEncargoPopup.layer.masksToBounds = true
        
        ratingPopup.layer.cornerRadius = 10
        ratingPopup.layer.masksToBounds = true
        
        let tapGestureRequests = UITapGestureRecognizer(target: self, action: #selector(moveToMapDetails))
        mapaImg.isUserInteractionEnabled = true
        mapaImg.addGestureRecognizer(tapGestureRequests)
        

        configureButtons()
        
        let distanceTxt = String(format: "%.2f", distance!)
        distanciaRestanteLabel.text = "Falta recorrer \(distanceTxt) metros de distancia"
        
        for starButton in starButtonCollection{
            starButton.setTitle("", for: .normal)
        }
        
    }
    
    
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        rating = sender.tag + 1
        print("Rating Oficial: \(ratingOficial ?? 0)")
        print("Reseña actual: \(recolector?.reseñaActual ?? 0)")
        
        // Guardar ID de la recoleccion en cuestion
        let  recoleccionDocumentID = recoleccion?.documentID
        
        db.collection("recolecciones").document(recoleccionDocumentID!).updateData([
            "recolector.suma_reseñas": FieldValue.increment(Int64(recolector?.reseñaActual ?? 0)),
            "estado": "Completada"
        ]){ err in
            if let err = err {
              print("Error updating document: \(err)")
            } else {
              print("Se actualizó la cantidad de reseñas")
            print(self.recolector?.reseñaActual ?? 0)
       
            }
        }
        self.navigationController?.popViewController(animated: true)
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
    
    
    @IBAction func finalizarRatingAction(_ sender: Any) {
        animateOut(desiredView: ratingPopup)
        // actualizar reseñas
        
    }
    
    
    @IBAction func finalizarEncargoActionTrue(_ sender: Any) {
        animateIn(desiredView: ratingPopup)
        animateOut(desiredView: finalizarEncargoPopup)
        
        // Guardar ID de la recoleccion en cuestion
        let  recoleccionDocumentID = recoleccion?.documentID
        
        db.collection("recolecciones").document(recoleccionDocumentID!).updateData([
            "recolector.cantidad_reseñas": FieldValue.increment(Int64(1))
            
        ]){ err in
            if let err = err {
              print("Error updating document: \(err)")
            } else {
              print("Se actualizó la reseña y cantidad de reseñas")
            print(self.recolector?.reseñaActual ?? 0)
       
            }
        }
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
    
    
    @IBAction func confirmarRechazarRecoleccionAction(_ sender: Any) {
        //añadir codigo restante
        // Guardar ID de la recoleccion en cuestion
        let  recoleccionDocumentID = recoleccion?.documentID
        
        db.collection("recolecciones").document(recoleccionDocumentID!).updateData([
            "estado": "Cancelada"
            
        ]){ err in
            if let err = err {
              print("Error updating document: \(err)")
            } else {
              print("Se canceló la recolección satisfactoriamente")
            }
        }
        animateOut(desiredView: rechazarEncargoPopup)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmarRecoleccion(_ sender: Any) {
        
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "ridesVC") as! RidesViewController

        // Pass the document ID to the next view controller
        nextViewController.distance = distance

        // Guardar ID de la recoleccion en cuestion
        let  recoleccionDocumentID = recoleccion?.documentID
        
        // Atributos
        let apellidos = recolector?.apellidos
        let cantidad_reseñas = recolector?.cantidad_reseñas
        let fotoUrl = recolector?.fotoUrl
        let recolectorID = recolector?.documentID
        let nombre = recolector?.nombre
        let suma_reseñas = recolector?.suma_reseñas
        let telefono = recolector?.telefono
        
     
        // Hacer el write en Firebase

        db.collection("recolecciones").document(recoleccionDocumentID!).updateData([
            "recolector.apellidos": apellidos!,
            "recolector.cantidad_reseñas": cantidad_reseñas!  ,
            "recolector.fotoUrl":  fotoUrl! ,
            "recolector.id": recolectorID!  ,
            "recolector.nombre":  nombre! ,
            "recolector.suma_reseñas":  suma_reseñas! ,
            "recolector.telefono": telefono! ,
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
