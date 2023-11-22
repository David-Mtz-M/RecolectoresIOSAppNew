//
//  MoreDetailsViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 16/11/23.
//

import UIKit
import AVFoundation

class MoreDetailsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var player: AVAudioPlayer?
    @IBOutlet weak var playSoundButton: UIButton!
    @IBOutlet weak var lbl_Description: UILabel!
    @IBOutlet weak var img_View: UIImageView!
    var img = UIImage()
    var des = ""
    var detalles: [String] = []
    var audioMapping : [String: String] = [
        "Aceite de auto": "aceiteauto",
        "Aceite usado": "aceiteusado",
        "Árbol": "arbol",
        "Baterias": "baterias",
        "Cartón": "carton",
        "Electrónicos": "electronicos",
        "Escombro": "escombro",
        "Industriales": "industriales",
        "Juguetes": "juguetes",
        "Libros": "libros",
        "Llantas": "lantas",
        "Madera": "madera",
        "Medicina": "medicina",
        "Metal": "metal",
        "Orgánico": "organico",
        "Pallets": "palltes",
        "Papel": "papel",
        "Pilas": "pilas",
        "Plásticos": "plasticos",
        "Ropa": "ropa",
        "Tapitas": "tapas",
        "Tetrapack": "tetrapack",
        "Toner": "toner",
        "Voluminoso": "voluminoso"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbl_Description.text = des
        img_View.image = img 
        
        //Boton redondo
        playSoundButton.layer.cornerRadius = playSoundButton.frame.size.width / 2
        playSoundButton.clipsToBounds = true
        
        if let firstElement = detalles.first, let audioFileName = audioMapping[firstElement], let path = Bundle.main.path(forResource: audioFileName, ofType: "mp3"){
            let url = NSURL(fileURLWithPath: path)
            
            do{
                player = try AVAudioPlayer(contentsOf: url as URL)
                player?.prepareToPlay()
                player?.delegate = self
            }
            catch{
                print("Couldn't create the player for \(firstElement). Error: \(error.localizedDescription)")
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
            playSoundButton.setTitle("Play", for: .normal)
        } else {
            player.play()
            playSoundButton.setTitle("Pause", for: .normal)
        }
    }
}
