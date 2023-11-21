//
//  MoreDetailsViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 16/11/23.
//

import UIKit
import AVFoundation

class MoreDetailsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?
    let audioFiles = ["aceiteAuto", "aceiteUsado", "arbol", "baterias", "bici", "botellas", "carton", "electronicos", "escombro", "industriales", "juguetes", "libros", "llantas", "madera", "medicina", "metal", "organico", "pallets", "papel", "pilas", "plasticos", "ropa", "tapas", "tetrapack", "toner", "voluminoso"]
    
    @IBAction func playSoundButton(_ sender: UIButton) {
        let index = sender.tag
        guard index >= 0, index < audioFiles.count else{
            print("Índice de botón no válido.")
            return
        }
        
        let fileName = audioFiles[index]
        
        playAudio(filename: fileName)
    }
    @IBOutlet weak var lbl_Description: UILabel!
    @IBOutlet weak var img_View: UIImageView!
    @IBOutlet weak var playSoundButton: UIButton!
    var img = UIImage()
    var des = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbl_Description.text = des
        img_View.image = img 
    }
    
    func playAudio(filename: String) {
        if let path = Bundle.main.path(forResource: filename, ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            
            do {
                audioPlayer?.stop()
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error al inicializar AVAudioPlayer: \(error.localizedDescription)")
            }
        }
    }
    


}
