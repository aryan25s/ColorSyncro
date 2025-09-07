//
//  FirebaseManager.swift
//  ColorSyncro
//
//  Created by Aryan Pradhan on 01/08/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth



class FirebaseManager {
    private let db = Firestore.firestore()
    
    // Upload one color item
    func uploadColor(_ item: ColorItem, completion: @escaping (Bool) -> Void) {
        
        print("⬆️ Attempting upload: \(item.hexCode)")
        
        let data: [String: Any] = [
            "hexCode": item.hexCode,
            "timestamp": item.timestamp
        ]
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ No authenticated user — cannot upload")
            completion(false)
            return
        }

        db.collection("users")
            .document(uid)
            .collection("colors")
            .addDocument(data: data) { error in
                if let error = error {
                    print("❌ Error uploading: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("✅ Color uploaded for user \(uid): \(item.hexCode)")
                    completion(true)
                }
            }
    }
    
    // Upload all stored items (e.g., after reconnecting to internet)
    func uploadAllColors(_ items: [ColorItem]) {
        for item in items {
            uploadColor(item) { _ in } // We ignore the result for bulk upload
        }
    }
}
