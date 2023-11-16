//
//  MoreDetailsViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 16/11/23.
//

import UIKit

class MoreDetailsViewController: UIViewController {
    
    @IBOutlet weak var lbl_Description: UILabel!
    @IBOutlet weak var img_View: UIImageView!
    
    var img = UIImage()
    var des = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbl_Description.text = des
        img_View.image = img 
    }
    


}
