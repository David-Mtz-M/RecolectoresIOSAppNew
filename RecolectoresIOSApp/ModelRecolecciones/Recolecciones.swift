//
//  Recolecciones.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 09/11/23.
//

import Foundation
import Firebase


class Recolecciones{
    var recoleccionesArray: [Recoleccion] = []
    var db: Firestore!
    
    init (){
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()){
        db.collection("recolecciones").addSnapshotListener { (QuerySnapshot, error) in
            guard error == nil else{
                print("ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.recoleccionesArray = [] // clean out existing recolectoresArray since new data will load
            
            for document in QuerySnapshot!.documents  {
                let recoleccion = Recoleccion(dictionary: document.data())
                recoleccion.documentID = document.documentID
                self.recoleccionesArray.append(recoleccion)
            }
            completed()
        }
    }
}
