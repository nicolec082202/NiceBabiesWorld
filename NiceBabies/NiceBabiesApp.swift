import SwiftUI  // Import SwiftUI framework for building user interfaces
import FirebaseCore  // Import FirebaseCore to configure Firebase services

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
            // The starting view of the app, in this case, LoginAppView
            LoginAppView()
        }
    }
}
