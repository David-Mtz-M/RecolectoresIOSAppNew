//
//  FavouritesViewController.swift
//  RecolectoresIOSApp
//
//  Created by Administrador on 07/11/23.
//

import UIKit


class FavouritesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()

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

