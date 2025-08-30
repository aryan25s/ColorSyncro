//
//  ViewController.swift
//  ColorSyncro
//  Created by Aryan Pradhan on 31/07/25.
//

import UIKit
import Firebase

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var generateColorButton: UIButton!
    @IBOutlet weak var colorCollectionview: UICollectionView!
    var colors: [ColorItem] = []
    let storage = LocalStorageManager()
    let firebaseManager = FirebaseManager()
    let networkMonitor = NetworkMonitor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        networkStatusLabel.text = NSLocalizedString("network_status_checking", comment: "")
        
        colorCollectionview.dataSource = self
        colorCollectionview.delegate = self
        
        colors = storage.loadColors()
        colorCollectionview.reloadData()
        
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                DispatchQueue.main.async {
                    self.networkStatusLabel.text = self.isConnected
                        ? NSLocalizedString("network_status_online", comment: "")
                        : NSLocalizedString("network_status_offline", comment: "")
                    self.networkStatusLabel.textColor = self.isConnected ? .systemGreen : .systemRed
                }
            }
        
        networkMonitor.monitor.pathUpdateHandler = {[weak self] path in
            DispatchQueue.main.async{
                let isConnected = path.status == .satisfied
                self?.networkStatusLabel.text = isConnected
                    ? NSLocalizedString("network_status_online", comment: "")
                    : NSLocalizedString("network_status_offline", comment: "")
                self?.networkStatusLabel.textColor = isConnected ? .systemGreen : .systemRed
                
                print("📶 isConnected = \(isConnected ? "Online" : "Offline")")
                
                if isConnected {
                    self?.firebaseManager.uploadAllColors(self?.colors ?? [])
                }
            }}
        
        networkMonitor.monitor.start(queue: DispatchQueue.global())
        
        
        
        
    }
    
    
    @IBOutlet weak var networkStatusLabel: UILabel!
    
    @IBAction func generateColorTapped(_ sender: UIButton) {
        let hex = generateRandomHex()
        let newItem = ColorItem(hexCode: hex, timestamp: Date())
        colors.append(newItem)
        storage.saveColors(colors)
        colorCollectionview.reloadData()
        
        firebaseManager.uploadColor(newItem) { success in
                if success {
                    print("✅ Synced to Firebase")
                } else {
                    print("❌ Failed to sync")
                }
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return colors.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let item = colors[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
            cell.colorView.backgroundColor = UIColor(hex: item.hexCode)
            cell.hexLabel.text = "#\(item.hexCode)"
            return cell
        }

        // MARK: Helper

        func generateRandomHex() -> String {
            let red = Int.random(in: 0...255)
            let green = Int.random(in: 0...255)
            let blue = Int.random(in: 0...255)
            return String(format: "%02X%02X%02X", red, green, blue)
        }
    
    var isConnected: Bool {
        return networkMonitor.isConnected
    }
    
    

}



