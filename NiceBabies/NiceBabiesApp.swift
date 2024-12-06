import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if OrientationManager.landscapeSupported {
            return .landscape // Allow only landscape orientation
        }
        return .portrait // Default to portrait orientation
    }
}

@main
struct NiceBabiesApp: App {
    // Link the custom AppDelegate to SwiftUI using UIApplicationDelegateAdaptor
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State  var gameCompleted: Bool = false
    
    var body: some Scene {
        WindowGroup {
            // Check if a user is already authenticated
            if Auth.auth().currentUser != nil {
                // User is signed in, show the main view
                HouseView(username: .constant(Auth.auth().currentUser?.email ?? "User"), gameCompleted: $gameCompleted)
            } else {
                // No user is signed in, show the login view
                LoginAppView()
            }
        }
    }
}
