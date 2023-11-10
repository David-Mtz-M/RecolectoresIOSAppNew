//
//  DetailsViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 07/11/23.
//

import UIKit


class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    private func configureItems(){
        
        var profileImg = UIImage(named: "profile")
        profileImg = profileImg?.withRenderingMode(.alwaysOriginal)
        
        var returnImg = UIImage(named: "returnIcon")
        returnImg = returnImg?.withRenderingMode(.alwaysOriginal)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImg, style: .done, target: self, action: #selector(moveToProfile))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: returnImg, style: .done, target: self, action: #selector(moveBackToOptions))
    }
    
    

    @objc private func moveBackToOptions() {
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "OptionsStoryboard") as! OpcionesViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    @objc private func moveToProfile() {
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileStoryboard") as! ProfileViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    @IBOutlet weak var detallesView: UITableView!
    
    let detalles = ["Aceite de auto", "Aceite usado", "Árbol", "Baterias", "Bici", "Botellas", "Cartón", "Electrónicos", "Escombro", "Industriales", "Juguetes", "Libros", "Llantas", "Madera", "Medicina", "Metal", "Orgánico", "Pallets", "Papel", "Pilas", "Plásticos", "Ropa", "Tapitas", "Tetrapack", "Toner", "Voluminoso"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detallesView.delegate = self
        detallesView.dataSource = self
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return detalles.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = detallesView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
            let detalle = detalles[indexPath.row]
            cell.residuoImg.image = UIImage(named: detalle)
            cell.infoLbl.text = detalle
            return cell
        }
        
        
    }
