import SwiftUI
import Firebase

struct HouseView: View {
    @State private var isGameCatalogViewPresented = false
    @State private var isClosetViewPresented = false
    @State private var isDollStatusViewPresented = false
    @State private var equippedBaby = "NiceBaby_Monkey"
    @State private var navigateToLogIn = false // State to trigger navigation
    @Binding var username: String
    @Binding var gameCompleted : Bool


    var body: some View {
        NavigationView { // Wrap content in NavigationView
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height

                ZStack {
                    // Background Image
                    Image("closetBackground")
                        .resizable()
                        .ignoresSafeArea()

                    // Button to present the GameCatalogView
                    Button(action: {
                        isGameCatalogViewPresented = true
                    }) {
                        Image("laptop")
                            .resizable()
                            .foregroundColor(Color.black)
                    }
                    .frame(width: width * 0.22, height: height * 0.1) // Set frame size relative to screen size
                    .contentShape(Rectangle())
                    .position(x: width * 0.79, y: height * 0.5) // Position relative to screen size
                    .fullScreenCover(isPresented: $isGameCatalogViewPresented) {
                        GameCatalogView(gameCompleted: $gameCompleted)
                    }

                    // Logout Button
                    Button(action: {
                        signOutUser()
                    }) {
                        Image(systemName: "arrow.forward.circle")
                            .foregroundColor(Color.black)
                            .font(.system(size: 35))
                    }
                    .position(x: width * 0.9, y: height * 0.02) // Position relative to screen size

                    // Button to present the ClosetView
                    Button(action: {
                        isClosetViewPresented = true
                    }) {
                        Image("closet1")
                            .resizable()
                            .foregroundColor(Color.black)
                    }
                    .frame(width: width * 0.71, height: height * 0.45) // Set frame size relative to screen size
                    .contentShape(Rectangle())
                    .position(x: width * 0.13, y: height * 0.26) // Position relative to screen size
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
                            .frame(width: width * 0.7, height: height * 0.7) // Set frame size relative to screen size
                    }
                    .frame(width: width * 0.2, height: height * 0.2) // Ensure button frame matches visible content
                    .contentShape(Rectangle())
                    .position(x: width * 0.6, y: height * 0.75) // Position relative to screen size
                    .fullScreenCover(isPresented: $isDollStatusViewPresented) {
                        DollStatusView(username: $username, equippedBaby: $equippedBaby, gameCompleted: $gameCompleted)
                    }

                    // NavigationLink for logging out
                    NavigationLink(destination: LoginAppView()
                        .navigationBarBackButtonHidden(true), isActive: $navigateToLogIn) {
                        EmptyView()
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





/*
// Preview of the HouseView for development in Xcode
struct HouseView_Previews: PreviewProvider {
    static var previews: some View {
        HouseView(username: .constant("thebaby"), gameCompleted: $gameCompleted)
    }
}
*/
