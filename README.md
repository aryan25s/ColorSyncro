ColorSyncro

An iOS app that generates random color hex codes, displays them on cards, and allows users to save them offline with timestamps. The app automatically syncs saved colors to Firebase when an internet connection is available, ensuring data is stored both locally and in the cloud.

🚀 Features

- ✅ Generate random hex color codes
- ✅ Display colors as scrollable cards (UICollectionView)
- ✅ Offline local storage using `UserDefaults` (persistent)
- ✅ Sync to Firebase Firestore when online
- ✅ Auto-sync on internet restoration
- ✅ Real-time network status display (🟢 Online / 🔴 Offline)
- ✅ Clean UI using Storyboard and Auto Layout

🧰 Tech Stack

| Component           | Technology          |
|---------------------|---------------------|
| Language            | Swift               |
| UI Framework        | UIKit + Storyboard  |
| Data Persistence    | UserDefaults        |
| Backend Sync        | Firebase Firestore  |
| Network Detection   | NWPathMonitor (Network framework) |

📁 Folder Structure
ColorSyncro
├── AppDelegate.swift
├── ViewController.swift
├── ColorItem.swift
├── ColorCell.swift
├── FirebaseManager.swift
├── LocalStorageManager.swift
├── NetworkMonitor.swift
├── UIColor+Hex.swift
├── Main.storyboard
├── Assets.xcassets
├── LaunchScreen.storyboard
├── Info.plist
├── GoogleService-Info.plist  <– 🔐 Required for Firebase

📲 How to Run the Project

✅ Prerequisites

- Xcode 14+ installed
- A Mac running macOS Ventura or later
- Firebase account with a Firestore project created

✅ Setup Steps

1. Clone the Repository**
```bash
git clone https://github.com/aryan25s/ColorSyncro.git
