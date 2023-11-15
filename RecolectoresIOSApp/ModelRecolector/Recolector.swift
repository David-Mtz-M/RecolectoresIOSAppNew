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

    
    
    enum CodingKeys: String, CodingKey {
        case nombre
        case apellidos
        case telefono
        case usuario

    }
    
    var dictionary: [String: Any]{
        return ["nombre": nombre, "apellidos": apellidos, "telefono": telefono, "usuario": usuario]
    }
    
    convenience init(){
        self.init( apellidos: "", telefono: "", usuario: "", nombre: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        
        // Use optional binding with if let to safely unwrap the values
        let nombre = dictionary["nombre"] as! String? ?? ""
        let apellidos = dictionary["apellidos"] as! String? ?? ""
        let telefono = dictionary["telefono"] as! String? ?? ""
        let usuario = dictionary["usuario"] as! String? ?? ""


        self.init( apellidos: apellidos, telefono: telefono, usuario: usuario, nombre: nombre)

    }

    
    init( apellidos: String, telefono: String, usuario: String, nombre: String) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.telefono = telefono
        self.usuario = usuario

        
    }
    
    
    
}
