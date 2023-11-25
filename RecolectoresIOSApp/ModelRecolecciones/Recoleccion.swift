//
//  Recoleccion.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 09/11/23.
//


import Foundation
import Firebase
import MapKit

class Recoleccion {
    var latitud: String
    var longitud: String
    var userInfo: [String: Any] = [:]
    var documentID: String?
    var userCoords: CLLocation
    var comentarios: String
    var materiales: [String: [String: Any]] = [:]
    var estado: String
    var fechaRecoleccion: String
    var horaRecoleccionInicio: String
    var horaRecoleccionFinal: String
    var recolector: [String: [String: Any]] = [:]


    var dictionary: [String: Any] {
        return ["recolector": recolector, "horaRecoleccionFinal": horaRecoleccionFinal, "horaRecoleccionInicio": horaRecoleccionInicio, "fechaRecoleccion": fechaRecoleccion, "estado": estado, "materiales": materiales,"comentarios": comentarios, "latitud": latitud, "longitud": longitud, "userInfo": userInfo, "userCoords": userCoords]
    }

    convenience init() {
        self.init(documentID: nil, latitud: "", longitud: "", userInfo: [:], userCoords: CLLocation(latitude: 0.0, longitude: 0.0),  comentarios: "", materiales: [:], estado: "", fechaRecoleccion: "", horaRecoleccionInicio: "", horaRecoleccionFinal: "", recolector: [:])
    }

    convenience init(dictionary: [String: Any]) {
        let latitud = dictionary["latitud"] as? String ?? ""
        let longitud = dictionary["longitud"] as? String ?? ""
        let userInfo = dictionary["userInfo"] as? [String: Any] ?? [:]
        let documentID = dictionary["documentID"] as? String
        let userCoords = dictionary["userCoords"] as? CLLocation ?? CLLocation(latitude: Double(latitud) ?? 0.0, longitude: Double(longitud) ?? 0.0)
        let comentarios = dictionary["comentarios"] as? String ?? ""
        let materiales = dictionary["materiales"] as? [String: [String: Any]] ?? [:]
        let estado = dictionary["estado"] as? String ?? ""
        let fechaRecoleccion = dictionary["fechaRecoleccion"] as? String ?? ""
        let horaRecoleccionInicio = dictionary["horaRecoleccionInicio"] as? String ?? ""
        let horaRecoleccionFinal = dictionary["horaRecoleccionFinal"] as? String ?? ""
        let recolector = dictionary["recolector"] as? [String: [String: Any]] ?? [:]

        self.init(documentID: documentID, latitud: latitud, longitud: longitud, userInfo: userInfo, userCoords: userCoords, comentarios: comentarios, materiales: materiales, estado: estado, fechaRecoleccion: fechaRecoleccion, horaRecoleccionInicio: horaRecoleccionInicio, horaRecoleccionFinal: horaRecoleccionFinal, recolector: recolector)
    }


    init(documentID: String?, latitud: String, longitud: String, userInfo: [String: Any], userCoords: CLLocation, comentarios: String, materiales: [String: [String: Any]] = [:], estado: String, fechaRecoleccion: String, horaRecoleccionInicio: String, horaRecoleccionFinal: String,
         recolector: [String: [String: Any]] = [:]) {
        self.latitud = latitud
        self.longitud = longitud
        self.userInfo = userInfo
        self.documentID = documentID
        self.userCoords = userCoords
        self.comentarios = comentarios
        self.materiales = materiales
        self.estado = estado
        self.fechaRecoleccion = fechaRecoleccion
        self.horaRecoleccionInicio = horaRecoleccionInicio
        self.horaRecoleccionFinal = horaRecoleccionFinal
        self.recolector = recolector
    }


    
    
    func getDistance(iphoneCoords: CLLocation) -> Double {
        let distance = iphoneCoords.distance(from: userCoords) 
        return distance
    }
}

