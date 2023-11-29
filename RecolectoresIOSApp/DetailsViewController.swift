//
//  DetailsViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 07/11/23.
//

import UIKit



class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    
    
    @IBOutlet weak var detallesView: UITableView!
    

    
    let detalles = ["Aceite Auto", "Aceite Usado", "Árbol", "Baterias", "Bicicletas", "Botellas", "Cartón", "Electrónicos", "Escombros", "Industriales", "Juguetes", "Libros", "Llantas", "Madera", "Medicina", "Metal", "Orgánico", "Pallets", "Papel", "Pilas", "Plásticos", "Ropa", "Tapitas", "Tetrapack", "Toner", "Voluminoso"]
    
    
    let descripcion = ["Este ícono sirve para saber que el material que se va a reciclar es aceite de auto.", "Este ícono sirve para saber que el material que se va a reciclar es aceite usado.", "Este ícono sirve para saber que el material que se va a reciclar son partes de árboles y arbustos.", "Este ícono sirve para saber que el material que se va a reciclar son baterías de carro.", "Este ícono sirve para saber que el material que se va a reciclar son partes de bicicleta.", "Este ícono sirve para saber que el material que se va a reciclar son botellas de vidrio.", "Este ícono sirve para saber que el material que se va a reciclar es cartón y sus derivados.", "Este ícono sirve para saber que el material que se va a reciclar son partes electrónicas y sus derivados.", "Este ícono sirve para saber que el material que se va a reciclar es escombro y desechos de obras.", "Este ícono sirve para saber que el material que se va a reciclar son desechos industriales y sus derivados.", "Este ícono sirve para saber que el material que se va a reciclar son juguetes y sus derivados.", "Este ícono sirve para saber que el material que se va a reciclar son libros usados y viejos.", "Este ícono sirve para saber que el material que se va a reciclar son llantas viejas y usadas.", "Este ícono sirve para saber que el material que se va a reciclar es madera vieja y usada.", "Este ícono sirve para saber que el material que se va a reciclar son medicamentos caducados.", "Este ícono sirve para saber que el material que se va a reciclar son residuos metálicos y sus derivados.", "Este ícono sirve para saber que el material que se va a reciclar es material orgánico y sus derivados.", "Este ícono sirve para saber que el material que se va a reciclar son armazones de madera utilizados para mover carga usados o destruidos.", "Este ícono sirve para saber que el material que se va a reciclar es papel y sus derivados.", "Este ícono sirve para saber que el material que se va a reciclar son pilas de uso común gastadas.", "Este ícono sirve para saber que el material que se va a reciclar es plástico PET y sus derivados.", "Este ícono sirve para saber que el material que se va a reciclar es ropa y calzado usado.", "Este ícono sirve para saber que el material que se va a reciclar son tapas de botellas PET o de garrafón.", "Este ícono sirve para saber que el material que se va a reciclar es tetrapack y sus derivados.", "Este ícono sirve para saber que el material que se va a reciclar son cartuchos de tinta usadas para impresoras.", "Este ícono sirve para saber que el material que se va a reciclar es un residuo de gran tamaño como muebles u electrodomésticos."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        detallesView.delegate = self
        detallesView.dataSource = self
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIcon = detalles[indexPath.row]
        let moreDetailsVC = storyboard?.instantiateViewController(withIdentifier: "MoreDetailsViewController") as! MoreDetailsViewController
        moreDetailsVC.selectedIcon = selectedIcon
        moreDetailsVC.detalles = detalles
        moreDetailsVC.img = UIImage(named: selectedIcon) ?? UIImage()
        moreDetailsVC.des = descripcion[indexPath.row]
        navigationController?.pushViewController(moreDetailsVC, animated: true)
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
    
    
    private func configureItems() {
        let defaults = UserDefaults.standard
        let recolectorInMemory = defaults.object(forKey: "SavedDict") as? [String: Any] ?? [String: Any]()
        let recolector = Recolector(dictionary: recolectorInMemory)
        let imgUrl = URL(string: recolector.fotoUrl)

        // Set a placeholder image
        let placeholderImage = UIImage(named: "placeholder") ?? UIImage()

        if let url = imgUrl {
            // Use the placeholder image initially
            self.updateNavigationBarItems(with: placeholderImage)

            DispatchQueue.global().async {
                do {
                    let imageData = try Data(contentsOf: url, options: .mappedIfSafe)
                    let bgImage = UIImage(data: imageData)

                    // Update the UI on the main queue
                    DispatchQueue.main.async {
                        if let bgImage = bgImage {
                            // Use bgImage as needed
                            self.updateNavigationBarItems(with: bgImage)
                        }
                    }
                } catch {
                    // Handle the error
                    print("Error downloading image: \(error.localizedDescription)")
                }
            }
        } else {
            // Handle invalid URL
            print("Invalid URL")
        }
    }


    private func updateNavigationBarItems(with image: UIImage) {
        // Resize the image to 40x40 pixels
        let resizedImage = image.resizedTo(width: 30, height: 30)

        let profileImg = resizedImage.withRenderingMode(.alwaysOriginal)
        let returnImg = UIImage(named: "returnIcon")?.withRenderingMode(.alwaysOriginal)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImg, style: .done, target: self, action: #selector(moveToProfile))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: returnImg, style: .done, target: self, action: #selector(moveBackToOptions))
    }


    
    @objc private func moveBackToOptions() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func moveToProfile() {
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileStoryboard") as! ProfileViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
}
