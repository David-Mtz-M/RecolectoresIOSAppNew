//
//  Recolectores.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 16/11/23.
//

import Foundation
import Firebase


class Recolectore{
    var recolectoresArray: [Recolector] = []
    var db: Firestore!
    
    init (){
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()){
        db.collection("recolectores").addSnapshotListener { (QuerySnapshot, error) in
            guard error == nil else{
                print("ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.recolectoresArray = [] // clean out existing recolectoresArray since new data will load
            
            for document in QuerySnapshot!.documents  {
                let recolector = Recolector(dictionary: document.data())
                //recolector.documentID = document.documentID
                self.recolectoresArray.append(recolector)
            }
            completed()
        }
    }
}
