//
//  DetailViewController.swift
//  Challenge1
//
//  Created by Adrimi on 18/03/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var ImageView: UIImageView!
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageToLoad = selectedImage {
            ImageView.image = UIImage(named: imageToLoad)
        }
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let image = ImageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found!")
            return
        }
        guard let imageName = selectedImage else {
            print("No image found!")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
        // additional code for IPAD
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
