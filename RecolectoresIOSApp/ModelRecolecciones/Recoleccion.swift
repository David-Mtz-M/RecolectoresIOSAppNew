//
//  Recoleccion.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 09/11/23.
//


import Foundation
import Firebase

class Recoleccion {
    
    
    var latitud: String
    var longitud: String
    var userInfo: [String: Any] = [:]
    var documentID: String

    
    
    var dictionary: [String: Any]{
        return ["latitud": latitud, "longitud": longitud, "userInfo": userInfo]
    }
    
    convenience init(){
        self.init(documentID: "", latitud: "", longitud: "", userInfo: [:] )
    }
    
    convenience init(dictionary: [String: Any]) {
        
        // Use optional binding with if let to safely unwrap the values
        let latitud = dictionary["latitud"] as! String? ?? ""
        let longitud = dictionary["longitud"] as! String? ?? ""
        let userInfo = dictionary["userInfo"] as! [String: Any]? ?? [:]
        let documentID = dictionary["documentID"] as! String? ?? ""

        self.init(documentID: "", latitud: latitud, longitud: longitud, userInfo: userInfo)

    }

    
    init(documentID: String, latitud: String, longitud: String, userInfo: [String: Any]) {
        self.latitud = latitud
        self.longitud = longitud
        self.userInfo = userInfo
        self.documentID = documentID
        
    }
    
    
    
}

