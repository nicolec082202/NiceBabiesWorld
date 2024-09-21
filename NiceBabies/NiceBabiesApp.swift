//
//  JournalAppApp.swift
//  JournalApp
//
//  Created by barbarella castillo on 7/10/23.
//

import SwiftUI
import FirebaseCore

/*
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
*/
@main
struct JournalAppApp: App {
    
    // register app delegate for Firebase setup
    //  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        
            WindowGroup {
                LoginAppView()
            }
        
    }
    
}
