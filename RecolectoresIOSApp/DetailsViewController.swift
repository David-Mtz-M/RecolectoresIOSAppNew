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
    let descripcion = ["Este ícono sirve para saber que el material que se va a reciclar es aceite de carro y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar es aceite usado y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar  son partes de árboles y arbustos", "Este ícono sirve para saber que el material que se va a reciclar son baterías de carro y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar son partes de bicicleta y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar son botellas de vidrio y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar es cartón y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar son partes electrónicas y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar es escombro y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar son desechos industriales y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar son juguetes y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar son libros y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar son llantas y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar es madera y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar son medicamentos y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar son residuos metálicos y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar es materíal orgánico y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar son pallets y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar es papel y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar son pilas de uso común y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar es plástico PET y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar es ropa usada y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar son tapas y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar es tetrapack y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar es toner y sus derivados", "Este ícono sirve para saber que el material que se va a reciclar es un residuo de gran tamaño y sus derivados"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detallesView.delegate = self
        detallesView.dataSource = self
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MoreDetailsViewController") as? MoreDetailsViewController {
            vc.img = UIImage(named: detalles[indexPath.row])!
            vc.des = descripcion[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
