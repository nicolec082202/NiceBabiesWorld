import SwiftUI  

// Define a view called DollStatusView
struct DollStatusView: View {
    
    // Use @Binding to get and update the value from a parent view
    @Binding var username: String  // Username of the user
    @State private var currentIndex = 0  // Track the current index (not used in this code snippet)
    @Binding var equippedBaby: String  // Name of the currently equipped baby or doll image

    // Access the environment to control the presentation mode of the view (dismiss or present)
    @Environment(\.presentationMode) var isDollStatusViewPresented
    
    var body: some View {
        
        
        // A ZStack to layer the components
        ZStack {
            // Button to dismiss the view
            Button(action: {
                // Dismiss the DollStatusView when the button is pressed
                isDollStatusViewPresented.wrappedValue.dismiss()
            }) {
                Image(systemName: "house.fill")  // House icon
                    .font(.system(size: 25))  // Set font size for the icon
                    .foregroundColor(Color.black)  // Set the icon color to black
            }
            .position(x: 50, y: 10)  // Position the button within the view
            
            // A vertical stack containing the username and hearts
            VStack {
                // Display the username with a font size of 30
                
  
                    Text("@" + username)
                        .font(.system(size: 30))
                    

                // HStack to display a row of heart icons
                HStack{
                    
                    let dollHearts = ["full_heart", "full_heart", "full_heart", "full_heart", "full_heart"]
                    
                    ForEach(dollHearts, id: \.self) { dollHeart in
                        
                        Image("full_heart")  // Red heart icon
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45.0, height: 80.0, alignment: .center)

                        
                        
                    }
                       /* Image("half_heart")  // Red heart icon
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 10.0, height: 110.0, alignment: .center)*/
                    
                }
            }
            .position(x: 200, y: 150)

              // Position the VStack
            
            // A VStack to display the equipped baby/doll image
            VStack {
                Image(equippedBaby)  // Load the image using the equippedBaby string
                    .resizable()  // Allow the image to resize
                    .aspectRatio(contentMode: .fit)  // Maintain the aspect ratio
                    .frame(width: 800, height: 1000)  // Set the size of the image
            }
            .zIndex(-1.0)  // Set the z-index to ensure it appears in the background
            .position(x: 200, y: 400)  // Position the VStack containing the image
        }
    }
}

// Preview for the DollStatusView
struct DollStatusView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide constant values for bindings in the preview
        DollStatusView(username: .constant("thebaby"), equippedBaby: .constant("NiceBaby_Monkey"))
    }
}
