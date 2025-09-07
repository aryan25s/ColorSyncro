import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()

        // Ensure the user is signed in anonymously
        signInAnonymously()

        return true
    }

    // MARK: - Anonymous Authentication
    private func signInAnonymously() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    print("❌ Anonymous sign-in failed: \(error.localizedDescription)")
                } else if let user = authResult?.user {
                    print("✅ Signed in anonymously with UID: \(user.uid)")
                }
            }
        } else {
            print("ℹ️ Already signed in with UID: \(Auth.auth().currentUser?.uid ?? "Unknown")")
        }
    }

    // MARK: UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
