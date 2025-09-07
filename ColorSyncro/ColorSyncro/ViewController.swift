import UIKit
import Firebase

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var generateColorButton: UIButton!
    @IBOutlet weak var colorCollectionview: UICollectionView!
    @IBOutlet weak var networkStatusLabel: UILabel!

    var colors: [ColorItem] = []
    let storage = LocalStorageManager()
    let firebaseManager = FirebaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        networkStatusLabel.text = NSLocalizedString("network_status_checking", comment: "")

        colorCollectionview.dataSource = self
        colorCollectionview.delegate = self

        colors = storage.loadColors()
        colorCollectionview.reloadData()

        // Observe network changes
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNetworkChange(_:)),
                                               name: .NetworkStatusDidChange,
                                               object: nil)

        // Set initial state from the monitor
        updateNetworkUI(connected: NetworkMonitor.shared.isConnected)

        // If we come online, try syncing any locally saved colors
        if NetworkMonitor.shared.isConnected {
            firebaseManager.uploadAllColors(colors)
        }
    }

    // MARK: - Network handling
    @objc private func handleNetworkChange(_ note: Notification) {
        let connected = (note.object as? Bool) ?? false
        updateNetworkUI(connected: connected)
        if connected {
            firebaseManager.uploadAllColors(colors)
        }
    }

    private func updateNetworkUI(connected: Bool) {
        networkStatusLabel.text = connected
            ? NSLocalizedString("network_status_online", comment: "")
            : NSLocalizedString("network_status_offline", comment: "")
        networkStatusLabel.textColor = connected ? .systemGreen : .systemRed
    }

    // MARK: - Button Action
    @IBAction func generateColorTapped(_ sender: UIButton) {
        let hex = generateRandomHex()
        let newItem = ColorItem(hexCode: hex, timestamp: Date())
        colors.append(newItem)
        storage.saveColors(colors)
        colorCollectionview.reloadData()

        // Firestore queues writes offline automatically
        firebaseManager.uploadColor(newItem) { success in
            print(success ? "✅ Synced to Firebase (or queued)" : "❌ Failed to sync")
        }
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = colors[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        cell.colorView.backgroundColor = UIColor(hex: item.hexCode)
        cell.hexLabel.text = "#\(item.hexCode)"
        return cell
    }

    // MARK: - Helpers
    private func generateRandomHex() -> String {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return String(format: "%02X%02X%02X", red, green, blue)
    }
}
