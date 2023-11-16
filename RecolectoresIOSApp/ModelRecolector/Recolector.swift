//
//  Recolectores.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 08/11/23.
//

import Foundation
import Firebase

class Recolector: Decodable {
    
    var nombre: String
    var apellidos: String
    var telefono: String
    var usuario: String
    var fotoUrl: String
    var cantidad_reseñas: Int
    var suma_reseñas: Int
    
    
    enum CodingKeys: String, CodingKey {
        case nombre
        case apellidos
        case telefono
        case usuario
        case fotoUrl
        case cantidad_reseñas
        case suma_reseñas


    }
    
    var dictionary: [String: Any]{
        return ["nombre": nombre, "apellidos": apellidos, "telefono": telefono, "usuario": usuario, "fotoUrl": fotoUrl, "cantidad_reseñas": cantidad_reseñas, "suma_reseñas": suma_reseñas]
    }
    
    convenience init() {
        self.init(apellidos: "", telefono: "", usuario: "", nombre: "", fotoUrl: "", cantidad_reseñas: 0, suma_reseñas: 0)
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
        



        self.init(apellidos: apellidos, telefono: telefono, usuario: usuario, nombre: nombre, fotoUrl: fotoUrl, cantidad_reseñas: cantidad_reseñas, suma_reseñas: suma_reseñas)

    }

    
    init( apellidos: String, telefono: String, usuario: String, nombre: String, fotoUrl: String, cantidad_reseñas: Int, suma_reseñas: Int) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.telefono = telefono
        self.usuario = usuario
        self.fotoUrl = fotoUrl
        self.cantidad_reseñas = cantidad_reseñas
        self.suma_reseñas = suma_reseñas

    }
    
    class func loadProfilePicture(imgUrl: URL, imgView: UIImageView) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imgUrl) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imgView.image = image // Set the image to UIImageView
                    }
                }
            }
        }
    }



    
}
