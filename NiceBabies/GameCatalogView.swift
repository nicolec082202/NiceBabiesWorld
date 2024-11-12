import SwiftUI

struct GameCatalogView: View {
    @Environment(\.presentationMode) var isGameCatalogViewPresented
    @State private var isWorkoutGamePresented = false
    @State private var isMatchingGamePresented = false
    @Binding var equippedBaby: String
    @Binding var username: String

    var body: some View {
        NavigationView { // Ensure GameCatalogView itself has a NavigationView context
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height

                ZStack {
                    HamburgerMenuView(isMenuOpen: false, username: $username, equippedBaby: $equippedBaby, currentView: "GameCatalogView")
                    
                    Text("Game Catalog View")
                        .font(.title)
                        .position(x: width * 0.5, y: height * 0.1)

                    VStack(spacing: height * 0.02) {
                        Button(action: {
                            isWorkoutGamePresented = true
                        }) {
                            Text("Launch Workout Game")
                                .font(.title2)
                                .padding()
                                .frame(width: width * 0.8)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .fullScreenCover(isPresented: $isWorkoutGamePresented) {
                            SpriteKitView(equippedBaby: $equippedBaby, gameType: .workout)
                                .edgesIgnoringSafeArea(.all)
                        }

                        Button(action: {
                            isMatchingGamePresented = true
                        }) {
                            Text("Launch Matching Game")
                                .font(.title2)
                                .padding()
                                .frame(width: width * 0.8)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .fullScreenCover(isPresented: $isMatchingGamePresented) {
                            SpriteKitView(equippedBaby: $equippedBaby, gameType: .matching)
                                .edgesIgnoringSafeArea(.all)
                        }
                    }
                    .frame(width: width, height: height)
                    .position(x: width * 0.5, y: height * 0.5)
                }
            }
            .navigationBarHidden(true) // Hide navigation bar if not needed
        }
    }
}


// Preview of the GameCatalogView for development in Xcode
struct GameCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        GameCatalogView(equippedBaby:.constant("NiceBaby_Monkey"), username: .constant("TheBaby"))
    }
}
