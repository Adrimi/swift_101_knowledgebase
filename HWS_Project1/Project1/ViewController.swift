//
//  ViewController.swift
//  Project1
//
//  Created by Adrimi on 06/03/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    var counters = [Counter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendTapped))
        
        loadCounter()
        
        performSelector(inBackground: #selector(fetchImages), with: nil)
    }
    
    @objc func fetchImages() {
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if (item.hasPrefix("nssl")) {
                pictures.append(item)
                if (counters.isEmpty) {
                    counters.append(Counter())
                }
            }
        }
        pictures.sort()
        
        // After fetching just reload table data
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    func loadCounter() {
        
        let defaults = UserDefaults.standard
        if let savedCounter = defaults.object(forKey: "counters") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                counters = try jsonDecoder.decode([Counter].self, from: savedCounter)
            } catch {
                print("failed to load counters")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    // this polymorphed method has cellForRowAt. This tells row number in Table.
    // this method puts stuff in the cell and returning it to use in storyboard.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // its like in adnroid. When a cell is out of the view, the queue reuse the cell and saves memory. When it's appear on the screen again, it will be called again. So, when you have like 100 rows on the screen, really is about 8-13, it's just reused again and again with changing name, icon and other properties.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // there is matching data of the picture with the cell info.
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Total views: \(counters[indexPath.row].counter)"
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let vc = DetailViewController()
//        vc.selectedImage = pictures[indexPath.row]
//        vc.indexOfSelectedImage = indexPath.row + 1
//        vc.totalImagesCount = pictures.count
//        performSegue(withIdentifier: "ShowDetails", sender: nil)
//
        counters[indexPath.row].counter += 1
        save()
        tableView.reloadData()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.indexOfSelectedImage = indexPath.row + 1
            vc.totalImagesCount = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func recommendTapped() {
        let vc = UIActivityViewController(activityItems: [title!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedCounters = try? jsonEncoder.encode(counters) {
            let defaults = UserDefaults.standard
            defaults.set(savedCounters, forKey: "counters")
        } else {
            print("Failed to save")
        }
    }
}

