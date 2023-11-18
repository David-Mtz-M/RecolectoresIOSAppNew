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
    
    @IBOutlet weak var horaRecoleccion: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundLabel.layer.cornerRadius = 10
        backgroundLabel.layer.masksToBounds = true
        
        // Set text color for labels
        nombreCliente.textColor = .white
        nombreCliente.font = UIFont.boldSystemFont(ofSize: nombreCliente.font.pointSize)
        
        distanciaEnMinutos.textColor = .white
        distanciaEnMinutos.font = UIFont.boldSystemFont(ofSize: distanciaEnMinutos.font.pointSize)
        
        direccion.textColor = .white
        
        horaRecoleccion.textColor = .white
        horaRecoleccion.font = UIFont.boldSystemFont(ofSize: distanciaEnMinutos.font.pointSize)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
