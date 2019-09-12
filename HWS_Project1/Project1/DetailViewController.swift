//
//  DetailViewController.swift
//  Project1
//
//  Created by Adrimi on 11/03/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var indexOfSelectedImage: Int?
    var totalImagesCount: Int?
    
    lazy var imgCount: Int = {
        let tbl = [1,2,3]
        let asd = totalImagesCount
        return tbl.count
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // optionals are unwrapped securely there
        if let a = indexOfSelectedImage, let b = totalImagesCount {
            title = "Picture \(a) of \(b)"
        } else {
            print("DEBUG - something happend in loading title!")
        }
        // It will not affect other screens, it do only in this place
        // for this screen only we don't want large Title
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
