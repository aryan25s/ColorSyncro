    //
    //  LocalStorageManager.swift
    //  ColorSyncro
    //
    //  Created by Aryan Pradhan on 01/08/25.
    //

    import Foundation

    class LocalStorageManager {
        private let key = "savedColors"

        func saveColors(_ colors: [ColorItem]) {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(colors) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }

        func loadColors() -> [ColorItem] {
            if let savedData = UserDefaults.standard.data(forKey: key) {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode([ColorItem].self, from: savedData) {
                    return decoded
                }
            }
            return []
        }
    }
