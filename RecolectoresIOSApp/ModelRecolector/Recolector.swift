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
    
    
    enum CodingKeys: String, CodingKey {
        case nombre
        case apellidos
        case telefono
        case usuario
        case fotoUrl


    }
    
    var dictionary: [String: Any]{
        return ["nombre": nombre, "apellidos": apellidos, "telefono": telefono, "usuario": usuario, "fotoUrl": fotoUrl]
    }
    
    convenience init() {
        self.init(apellidos: "", telefono: "", usuario: "", nombre: "", fotoUrl: "")
    }

    
    convenience init(dictionary: [String: Any]) {
        
        // Use optional binding with if let to safely unwrap the values
        let nombre = dictionary["nombre"] as! String? ?? ""
        let apellidos = dictionary["apellidos"] as! String? ?? ""
        let telefono = dictionary["telefono"] as! String? ?? ""
        let usuario = dictionary["usuario"] as! String? ?? ""
        let fotoUrl = dictionary["fotoUrl"] as! String? ?? ""



        self.init(apellidos: apellidos, telefono: telefono, usuario: usuario, nombre: nombre, fotoUrl: fotoUrl)

    }

    
    init( apellidos: String, telefono: String, usuario: String, nombre: String, fotoUrl: String) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.telefono = telefono
        self.usuario = usuario
        self.fotoUrl = fotoUrl

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
