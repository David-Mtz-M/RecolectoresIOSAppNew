//
//  LogOutViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 24/11/23.
//

import UIKit

class LogOutViewController: UIViewController {
    
    @IBOutlet weak var MailField: UITextField!
    @IBOutlet weak var secondLogOut: UIButton!
    
    
    //Se realiza un pop up para avisar del cierre de sesión
    
    @IBAction func popUpTagged(_ sender: UIButton) {
        let alertController = UIAlertController(title: "¿Seguro?", message: "Esta acción es irreversible", preferredStyle: .alert)
        //Botón que hace que el usuario cierre sesión
        let acceptAction = UIAlertAction(title: "Salir", style: .default) {_ in
        print("Botón Aceptar Presionado")
        }
        alertController.addAction(acceptAction)
        
        //Botón que hace que se cancele el cierre de sesión
        let closeAction = UIAlertAction(title: "Cancelar", style: .cancel) {_ in
            print("Pop up cerrado")
        }
        alertController.addAction(closeAction)
        
        //Hace en negrita la acción principal
        alertController.preferredAction = acceptAction
        present(alertController, animated: true, completion: nil)
    }
    
    
}



