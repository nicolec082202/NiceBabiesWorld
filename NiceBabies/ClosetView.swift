import SwiftUI  

// Define the ClosetView structure conforming to the View protocol
struct ClosetView: View {
    var body: some View {
        // Use a VStack to vertically stack elements
        VStack {
            
            // HStack to display the "Collection" label and a plus icon horizontally
            HStack {
                Text("Collection")  // Display the text "Collection"
                Image(systemName: "plus.circle")  // Display a plus circle icon
            }
            .font(.system(size: 45))  // Set the font size for both elements
            .position(x: 200, y: 70)  // Position the HStack within the view
            
            // HStack to display the first row of baby images
            HStack {
                Image("NiceBaby_Fish")  // Load the fish-themed baby image
                    .resizable()  // Allow the image to resize
                    .aspectRatio(contentMode: .fit)  // Maintain aspect ratio
                
                Image("NiceBaby_Monkey")  // Load the monkey-themed baby image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Image("NiceBaby_Sheep")  // Load the sheep-themed baby image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            // Add a horizontal divider between rows
            Divider()
                .frame(width: 320, height: 10)  // Set the divider’s size
                .overlay(.black)  // Set the divider’s color to black
            
            // HStack to display the second row of baby images
            HStack {
                Image("NiceBaby_Panda")  // Load the panda-themed baby image
                    .resizable()
                
                Image("NiceBaby_Rabbit")  // Load the rabbit-themed baby image
                    .resizable()
                
                Image("NiceBaby_Cow")  // Load the cow-themed baby image
                    .resizable()
            }
            
            // Add another horizontal divider between rows
            Divider()
                .frame(width: 320, height: 10)
                .overlay(.black)
            
            Spacer()  // Add a spacer to push content to the top
        }
    }
}

// Preview of the ClosetView for development in Xcode
struct ClosetView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView()  // Display the ClosetView in preview mode
    }
}
