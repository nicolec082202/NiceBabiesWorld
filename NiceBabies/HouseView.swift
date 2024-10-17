import SwiftUI  

// Define the HouseView structure conforming to the View protocol
struct HouseView: View {
    
    // State variables to manage the presentation of different views
    @State private var isGameCatalogViewPresented = false  // Track if GameCatalogView is shown
    @State private var isDollStatusViewPresented = false  // Track if DollStatusView is shown
    @State private var equippedBaby = "NiceBaby_Monkey"  // Store the current equipped baby image
    
    // Binding to receive the username from the parent view
    @Binding var username: String

    var body: some View {
        // Use a ZStack to layer the components
        ZStack {
            // Window image representing a house window, positioned at the top
            Image(systemName: "window.horizontal.closed")
                .font(.system(size: 100))  // Set the font size for the window icon
                .position(x: 200, y: 175)  // Position the window in the view
            
            // Button to present the GameCatalogView
            Button(action: {
                isGameCatalogViewPresented = true  // Set state to true to show the game catalog
            }) {
                Image(systemName: "play.laptopcomputer")  // Laptop icon
                    .font(.system(size: 70))  // Set the icon size
                    .foregroundColor(Color.black)  // Set the icon color to black
            }
            .frame(width: 60, height: 50)  // Set the button's frame size
            .contentShape(Rectangle())  // Ensure only the button's shape is clickable
            .position(x: 70, y: 355)  // Position the button in the view
            .fullScreenCover(isPresented: $isGameCatalogViewPresented) {
                GameCatalogView()  // Show the GameCatalogView as a full-screen cover
            }
            
            // Table icon positioned below the game catalog button
            Image(systemName: "table.furniture.fill")
                .font(.system(size: 100))  // Set the icon size for the table
                .position(x: 70, y: 425)  // Position the table in the view
            
            // Bed icon positioned to the right side of the table
            Image(systemName: "bed.double.fill")
                .font(.system(size: 95))  // Set the icon size for the bed
                .position(x: 320, y: 425)  // Position the bed in the view
            
            // Button to present the DollStatusView, displaying the equipped baby image
            Button(action: {
                isDollStatusViewPresented = true  // Set state to true to show the doll status view
            }) {
                Image(equippedBaby)  // Load the equipped baby image
                    .resizable()  // Allow the image to be resized
                    .aspectRatio(contentMode: .fit)  // Maintain the aspect ratio of the image
                    .frame(width: 300, height: 550)  // Set the image size
            }
            // Control the clickable area to only the image’s frame
            .frame(width: 135, height: 175)  // Ensure button frame matches the visible content
            .contentShape(Rectangle())  // Limit the clickable area to the button shape
            .position(x: 200, y: 520)  // Position the button in the view
            .fullScreenCover(isPresented: $isDollStatusViewPresented) {
                // Show the DollStatusView with the username and equipped baby
                DollStatusView(username: $username, equippedBaby: $equippedBaby)
            }
        }
    }
}

// Preview of the HouseView for development in Xcode
struct HouseView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a constant username for the preview
        HouseView(username: .constant("thebaby"))
    }
}
