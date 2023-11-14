//
//  MaterialTableViewCell.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 14/11/23.
//

import UIKit

class MaterialTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fotoMaterial: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
