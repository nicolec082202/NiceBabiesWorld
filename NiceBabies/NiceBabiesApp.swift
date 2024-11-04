import SwiftUI  // Import SwiftUI framework for building user interfaces
import Firebase

@main  // Entry point of the SwiftUI app
struct NiceBabiesApp: App {  // Define the main structure conforming to the App protocol
    
    // Register app delegate for Firebase setup (commented out, possibly for future use)
    // @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        // Initialize Firebase when the app starts
        FirebaseApp.configure()
    }
    
    var body: some Scene {  // Define the body of the app, which contains the main scene(s)
        WindowGroup {
            // Check if a user is already authenticated
            if Auth.auth().currentUser != nil {
                // User is signed in, show the main view
                HouseView(username: .constant(Auth.auth().currentUser?.email ?? "User"))
            } else {
                // No user is signed in, show the login view
                LoginAppView()
            }
        }
    }
}
