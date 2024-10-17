import SwiftUI 

// Main view to display a catalog of games
struct GameCatalogView: View {
    
    // Access the environment to control the presentation mode (dismiss or present this view)
    @Environment(\.presentationMode) var isGameCatalogViewPresented
    // State variable to track if the mini-game is being presented
    @State private var isGamePresented = false

    var body: some View {
        
        // ZStack to layer the elements on top of each other
        ZStack {
            
            // Button to dismiss the GameCatalogView and return to the previous view
            Button(action: {
                isGameCatalogViewPresented.wrappedValue.dismiss()  // Dismiss the current view
            }) {
                Image(systemName: "house.fill")  // House icon
                    .font(.system(size: 25))  // Set the icon size
                    .foregroundColor(Color.black)  // Set the icon color to black
            }
            .position(x: 50, y: 10)  // Position the button within the view

            // Text to display the title of the catalog view
            Text("Game Catalog View")
                .position(x: 200, y: 30)  // Position the text within the view

            // Button to present the mini-game
            Button(action: {
                isGamePresented = true  // Set the state to true to present the game
            }) {
                Text("Play Mini-Game")  // Button text
                    .font(.title)  // Set font size to title
                    .padding()  // Add padding around the text
                    .background(Color.blue)  // Set the background color to blue
                    .foregroundColor(.white)  // Set the text color to white
                    .cornerRadius(10)  // Round the corners of the button
            }
            // Present the GameView as a full-screen cover when the button is tapped
            .fullScreenCover(isPresented: $isGamePresented) {
                GameView(isGamePresented: $isGamePresented)  // Pass binding to control dismissal
            }
        }
    }
}

// View representing the game using SpriteKit
struct GameView: View {
    // Binding to control whether the game is being presented or dismissed
    @Binding var isGamePresented: Bool

    var body: some View {
        // Display the SpriteKitView, which is your game content
        SpriteKitView()
            .overlay(
                // Overlay a close button to dismiss the game
                Button(action: {
                    isGamePresented = false  // Dismiss the game and return to the catalog
                }) {
                    Image(systemName: "xmark.circle.fill")  // Close icon
                        .font(.system(size: 40))  // Set the icon size
                        .padding()  // Add padding around the icon
                        .foregroundColor(.white)  // Set the icon color to white
                }
                // Position the close button in the top-right corner
                .position(x: UIScreen.main.bounds.width - 50, y: 50), alignment: .topTrailing
            )
    }
}

// Preview for the GameCatalogView in Xcode
struct GameCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        GameCatalogView()  // Display the view in preview mode
    }
}
