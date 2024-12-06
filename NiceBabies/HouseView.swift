import SwiftUI
import Firebase

struct HouseView: View {
    @State private var isClosetViewPresented = false
    @State private var isDollStatusViewPresented = false
    @State var equippedBaby = ""
    @State private var navigateToLogIn = false // State to trigger navigation
    @State var username = ""

    var body: some View {
        NavigationView { // Wrap content in NavigationView
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height

                ZStack {
                    // Background Image
                    Image("HomePage Background")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)          .frame(width: width * 1.59, height: height)
                        .position(x: width * 0.5, y: height * 0.5)
                    
                    // Hamburger Menu
                    HamburgerMenuView(isMenuOpen: false, currentView: "HouseView")
                    
                    // NavigationLink for GameCatalogView
                    NavigationLink(destination: GameCatalogView().navigationBarHidden(true)) {
                        Image("Laptop")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width * 0.4, height: height * 0.4)
                    }
                    .frame(width: width * 0.4, height: height * 0.2)
                    .contentShape(Rectangle())
                    .position(x: width * 0.38, y: height * 0.33) // Position relative to screen size
                    
                    // Button to present the ClosetView
                    Button(action: {
                        isClosetViewPresented = true
                    }) {
                        Image("Closet")
                            .resizable()
                            .frame(width: width * 0.26, height: height * 0.3)
                    }
                    .frame(width: width * 0.26, height: height * 0.23) // Set frame size relative to screen size
                    .contentShape(Rectangle())
                    .position(x: width * 0.7, y: height * 0.32) // Position relative to screen size
                    .fullScreenCover(isPresented: $isClosetViewPresented) {
                        ClosetView(equippedBaby: $equippedBaby)
                    }

                    // Button to present the DollStatusView
                    Button(action: {
                        isDollStatusViewPresented = true
                    }) {
                        Image(equippedBaby)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width * 0.5, height: height * 0.5) // Set frame size relative to view dimensions
                    }
                    .frame(width: width * 0.2, height: height * 0.2) // Ensure button frame matches visible content
                    .contentShape(Rectangle())
                    .position(x: width * 0.5, y: height * 0.65) // Position relative to screen size
                    .fullScreenCover(isPresented: $isDollStatusViewPresented) {
                        DollStatusView()
                    }
                }
                .onAppear{
                    
            // Fetch username
                    fetchUserData(for: "username") { value, error in
                        if let error = error {
                            print("Error fetching username: \(error.localizedDescription)")
                        } else if let fetchedUsername = value as? String {
                            username = fetchedUsername
                        }
                    }

                    // Fetch equippedBaby
                    fetchUserData(for: "equippedBaby") { value, error in
                        if let error = error {
                            print("Error fetching equippedBaby: \(error.localizedDescription)")
                        } else if let fetchedEquippedBaby = value as? String {
                            equippedBaby = fetchedEquippedBaby
                        }
                    }
                }
                
            }
            .navigationBarHidden(true) // Hide navigation bar if not needed
        }
    }

    func signOutUser() {
        do {
            try Auth.auth().signOut() // Firebase sign out
            navigateToLogIn = true // Trigger navigation
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}

// Preview of the HouseView for development in Xcode
struct HouseView_Previews: PreviewProvider {
    static var previews: some View {
        HouseView()
    }
}
