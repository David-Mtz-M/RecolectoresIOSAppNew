//
//  MoreDetailsViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 16/11/23.
//

import UIKit
import AVFoundation

class MoreDetailsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var selectedIcon: String?
    var player: AVAudioPlayer?
    @IBOutlet weak var playSoundButton: UIButton!
    @IBOutlet weak var lbl_Description: UILabel!
    @IBOutlet weak var img_View: UIImageView!
    var img = UIImage()
    var des = ""
    var detalles: [String] = []
    //Diccionario que lee el ícono del array e identifica el nombre del archivo mp3 del ícono
    

    var audioMapping : [String: String] = [
        "Aceite de Auto": "acieteauto-2",
        "Aceite Usado": "aceiteusado-2",
        "Árbol": "arbol-2",
        "Baterías": "baterias-2",
        "Bicicletas": "bici-2",
        "Botellas": "botellas-2",
        "Cartón": "carton-2",
        "Electrónicos": "electronicos-2",
        "Escombros": "escombro-2",
        "Industriales": "industriales-2",
        "Juguetes": "juguetes-2",
        "Libros": "libros-2",
        "Llantas": "llantas-2",
        "Madera": "madera-2",
        "Medicinas": "medicina-2",
        "Metal": "metal-2",
        "Orgánico": "organico-2",
        "Pallets": "pallets",
        "Papel": "papel-2",
        "Pilas": "pilas-2",
        "Plásticos": "plasticos-2",
        "Ropa": "audio_material_ropa-2",
        "Tapitas": "tapas-3",
        "Tetra Pack": "tetrapack",
        "Toner": "toner-2",
        "Voluminoso": "voluminoso-2"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()

        lbl_Description.text = des
        img_View.image = img
        
        playSoundButton.setTitle("", for: .normal)
        
        //Boton redondo
        playSoundButton.layer.cornerRadius = playSoundButton.frame.size.width / 2
        playSoundButton.clipsToBounds = true
        
        if let selectedIcon = selectedIcon, let audioFileName = audioMapping[selectedIcon], let path = Bundle.main.path(forResource: audioFileName, ofType: "mp3"){
            let url = URL(fileURLWithPath: path)
            
            do{
                player = try AVAudioPlayer(contentsOf: url as URL)
                player?.prepareToPlay()
                player?.delegate = self
            }
            catch{
                print("Couldn't create the player. Error: \(error.localizedDescription)")
            }
        }
    }

    @IBAction func playButtonTapped(_ sender: UIButton) {
        guard let player = player else {
            print("Player not configurated.")
            return
        }
        if player.isPlaying {
            player.stop()
        } else {
            player.play()
        }
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


