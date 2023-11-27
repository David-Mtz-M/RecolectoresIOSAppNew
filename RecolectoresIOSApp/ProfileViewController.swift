//
//  ProfileViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 07/11/23.
//

import UIKit
import Firebase


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    
    
    @IBOutlet weak var nombreRecolectorLabel: UILabel!
    
    @IBOutlet weak var cerrarSesionButton: UIButton!
    
    @IBOutlet weak var correoRecolectorLabel: UILabel!
    
    @IBOutlet weak var historialButton: UIButton!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        imagePicker.delegate = self
        //Imagen Redonda
        profileImageView.backgroundColor = .clear
        profileImageView.layer.masksToBounds = true
        //profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        //Botón de cambio de perfil redonda
        //changeImageButton.layer.cornerRadius = changeImageButton.frame.size.height / 2
        //changeImageButton.layer.cornerRadius = changeImageButton.frame.size.width / 2
        //changeImageButton.clipsToBounds = true
        
        changeImageButton.setTitle("", for: .normal)
        
        //Boton de historial personalizado
        let corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        historialButton.layer.cornerRadius = 20
        historialButton.layer.maskedCorners = corners
        //Botón de cerrar sesión personalizdo
        let corners2: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        cerrarSesionButton.layer.cornerRadius = 20
        cerrarSesionButton.layer.maskedCorners = corners2
        
        let defaults = UserDefaults.standard
        let recolectorInMemory = defaults.object(forKey: "SavedDict") as? [String: Any] ?? [String: Any]()
        let recolector = Recolector(dictionary: recolectorInMemory)
        
        let imgUrl = URL(string: recolector.fotoUrl)
        let correo = defaults.string(forKey: "email")
        
        
        Recolector.loadProfilePicture(imgUrl: imgUrl!, imgView: profileImageView)
        
        nombreRecolectorLabel.text = recolector.nombre + " " + recolector.apellidos
        correoRecolectorLabel.text = correo


    }
    

    
    
    @IBAction func changeImageTapped(_ sender: UIButton){
        let alertController = UIAlertController(title: "Seleccionar Foto", message: "¿Cómo desea tomar la foto?", preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Tomar Foto", style: .default) { [unowned self] _ in
            self.showImagePicker(sourceType: .camera)
        }
        let choosePhotoAction = UIAlertAction(title: "Elegir de la Galería", style: .default) { [unowned self] _ in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(takePhotoAction)
        alertController.addAction(choosePhotoAction)
        alertController.addAction(cancelAction)
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            profileImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showImagePicker (sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
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



