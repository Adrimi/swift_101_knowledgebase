//
//  ViewController.swift
//  Challenge1
//
//  Created by Adrimi on 18/03/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Challenge 1"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if (item.hasSuffix(".png")) {
                pictures.append(item)
            }
        }
        pictures.sort()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.imageView?.image = UIImage(named: pictures[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetainViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success. Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            // 3. now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
            
        }
     }


}

