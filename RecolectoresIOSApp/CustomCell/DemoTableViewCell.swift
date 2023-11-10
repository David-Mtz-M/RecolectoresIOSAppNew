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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
