//
//  Recolector.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 16/11/23.
//

import Firebase

class Recolector {
    
    var nombre: String
    var apellidos: String
    var telefono: String
    var usuario: String
    var fotoUrl: String
    var cantidad_reseñas: Int
    var suma_reseñas: Int
    var documentID: String?
    var reseñaActual: Int
    
    
    var dictionary: [String: Any]{
        return [ "nombre": nombre, "apellidos": apellidos, "telefono": telefono, "usuario": usuario, "fotoUrl": fotoUrl, "cantidad_reseñas": cantidad_reseñas, "suma_reseñas": suma_reseñas, "reseñaActual": reseñaActual]
    }
    
    convenience init() {
        self.init(apellidos: "", telefono: "", usuario: "", nombre: "", fotoUrl: "", cantidad_reseñas: 0, suma_reseñas: 0, documentID: nil, reseñaActual: 0)
    }

    
    convenience init(dictionary: [String: Any]) {
        
        // Use optional binding with if let to safely unwrap the values
        let nombre = dictionary["nombre"] as! String? ?? ""
        let apellidos = dictionary["apellidos"] as! String? ?? ""
        let telefono = dictionary["telefono"] as! String? ?? ""
        let usuario = dictionary["usuario"] as! String? ?? ""
        let fotoUrl = dictionary["fotoUrl"] as! String? ?? ""
        let cantidad_reseñas = dictionary["cantidad_reseñas"] as! Int? ?? 0
        let suma_reseñas = dictionary["suma_reseñas"] as! Int? ?? 0
        let documentID = dictionary["documentID"] as? String
        let reseñaActual = dictionary["reseñaActual"] as! Int? ?? 0
        



        self.init(apellidos: apellidos, telefono: telefono, usuario: usuario, nombre: nombre, fotoUrl: fotoUrl, cantidad_reseñas: cantidad_reseñas, suma_reseñas: suma_reseñas, documentID: documentID, reseñaActual: reseñaActual)

    }

    
    init( apellidos: String, telefono: String, usuario: String, nombre: String, fotoUrl: String, cantidad_reseñas: Int, suma_reseñas: Int, documentID: String?, reseñaActual: Int) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.telefono = telefono
        self.usuario = usuario
        self.fotoUrl = fotoUrl
        self.cantidad_reseñas = cantidad_reseñas
        self.suma_reseñas = suma_reseñas
        self.documentID = documentID
        self.reseñaActual = reseñaActual

    }
    
    class func loadProfilePicture(imgUrl: URL, imgView: UIImageView, placeholderImage: UIImage? = nil) {
        // Use the placeholder image initially
        imgView.image = placeholderImage ?? UIImage(named: "placeholder")

        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: imgUrl),
               let bgImage = UIImage(data: imageData) {
                // Update the UI on the main queue
                DispatchQueue.main.async {
                    imgView.image = bgImage
                }
            } else {
                // Handle the error
                print("Error downloading image")
            }
        }
    }




    
    
    
    
    

    

    
}
