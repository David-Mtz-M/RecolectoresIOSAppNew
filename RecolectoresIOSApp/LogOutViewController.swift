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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Se realiza un pop-up para avisar del cierre de sesión
    @IBAction func popUpTagged(_ sender: UIButton) {
        let alertController = UIAlertController(title: "¿Seguro?", message: "Esta acción es irreversible", preferredStyle: .alert)
        
        // Botón que hace que el usuario cierre sesión
        let acceptAction = UIAlertAction(title: "Salir", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            print("Botón Aceptar Presionado")
            
            let savedData = UserDefaults.standard
            let correo = savedData.string(forKey: "email")
            
            if self.MailField.text == correo {
                // Move to ViewController
                    let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "logInStoryboard") as! ViewController
                    self.navigationController?.pushViewController(mainViewController, animated: true)
            } else {
                // Muestra un mensaje indicando que el correo es incorrecto
                print("Correo incorrecto. Cierre de sesión cancelado.")
            }
        }
        alertController.addAction(acceptAction)
        
        // Botón que hace que se cancele el cierre de sesión
        let closeAction = UIAlertAction(title: "Cancelar", style: .cancel) { _ in
            print("Pop up cerrado")
        }
        alertController.addAction(closeAction)
        
        // Hace en negrita la acción principal
        alertController.preferredAction = acceptAction
        
        present(alertController, animated: true, completion: nil)
    }
}
