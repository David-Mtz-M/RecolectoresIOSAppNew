//
//  Recolectores.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 08/11/23.
//

import Foundation
import Firebase

class Recolector {
    
    
    var apellidos: String
    var telefono: String
    var usuario: String
    var documentID: String
    
    var dictionary: [String: Any]{
        return ["apellidos": apellidos, "telefono": telefono, "usuario": usuario]
    }
    
    convenience init(){
        self.init(documentID: "", apellidos: "", telefono: "", usuario: "" )
    }
    
    convenience init(dictionary: [String: Any]) {
        
        // Use optional binding with if let to safely unwrap the values
        let apellidos = dictionary["apellidos"] as! String? ?? ""
        let telefono = dictionary["telefono"] as! String? ?? ""
        let usuario = dictionary["usuario"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""

        self.init(documentID: "", apellidos: apellidos, telefono: telefono, usuario: usuario)

    }

    
    init(documentID: String, apellidos: String, telefono: String, usuario: String) {
        self.apellidos = apellidos
        self.telefono = telefono
        self.usuario = usuario
        self.documentID = documentID
        
    }
    
    
    
}
