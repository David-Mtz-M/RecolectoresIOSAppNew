//
//  DemoTableViewCell.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 09/11/23.
//

import UIKit

class DemoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fotoRecoleccion: UIImageView!
    @IBOutlet weak var nombreCliente: UILabel!
    @IBOutlet weak var distanciaEnMinutos: UILabel!
    @IBOutlet weak var direccion: UILabel!
    @IBOutlet weak var backgroundLabel: UILabel!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundLabel.layer.cornerRadius = 10
        backgroundLabel.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
