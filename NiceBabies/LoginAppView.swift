import SwiftUI  // Import SwiftUI framework for building the UI
import Firebase  // Import Firebase to handle authentication and Firestore operations

// Define the LoginAppView conforming to the View protocol
struct LoginAppView: View {
    // State variables to store user input and manage view state
    @State var email: String = ""  // Store email input
    @State var password: String = ""  // Store password input
    @State var username: String = ""  // Store the username retrieved from Firestore

    @State private var isCreateAccountViewPresented = false  // Manage "Create Account" view presentation
    @State private var isPasswordCorrect: Bool = false  // Control navigation to the next view
    @State private var showErrorAlert: Bool = false  // Show an alert on login error
    

    var body: some View {
        // Use a NavigationStack for navigation between views
        NavigationStack {
            ZStack {
                
                VStack {
<<<<<<< Updated upstream
                    Spacer()  // Add space at the top
                    
                    // Header: App title
                    HStack {
                        Spacer()
                        Text("Nice Babies World")
                            .font(.system(size: 20))  // Set the font size
                            .padding(.bottom, 16)  // Add padding below the text
                        Spacer()
                    }
                    
                    // Sign-in/Sign-up section
                    HStack {
                        Spacer()
                        Text("sign in")
                            .font(.system(size: 20))
                            .padding(.trailing, 16)
                            .fontWeight(.semibold)  // Set font weight to semibold
                            .underline()  // Underline the text
                        
                        // Button to present "Create Account" view
                        Button(action: {
                            isCreateAccountViewPresented.toggle()
                        }) {
                            Text("sign up")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                        .sheet(isPresented: $isCreateAccountViewPresented) {
                            NewAccountView()  // Present NewAccountView in a sheet
                        }
                        Spacer()
                    }
                    .padding(.bottom, 32)  // Add padding below the section
=======
                
                    HStack{
                        Image("Nice Babies Logo")
                            .resizable()
                            .frame(width: 250, height: 150)
                            .clipped()
                            .padding(.top, 70)
                            .padding(.bottom, 40)
                    }
                        
                   
>>>>>>> Stashed changes
                    
                    // Email input field with validation
                    HStack {
                        Image(systemName: "person.fill")  // Person icon
                            .padding(.leading, 16)
<<<<<<< Updated upstream
                        TextField("email", text: $email)  // Input for email
=======
                        TextField("Email", text: $email)
>>>>>>> Stashed changes
                            .font(.system(size: 20))
                        
                        // Show checkmark or crossmark based on email validity
                        if !email.isEmpty {
                            Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                                .padding(.trailing, 16)
                                .foregroundColor(email.isValidEmail() ? .green : .red)
                        }
                    }
                    .padding()
<<<<<<< Updated upstream
                    .background(Color(red: 0.16, green: 0.5, blue: 0.9).opacity(0.2))  // Background with light blue tint
                    .cornerRadius(90)  // Rounded corners
                    .padding(.bottom, 16)  // Padding below the field
=======
                    .background(Color(red: 0.61, green: 0.54, blue: 0.72))
                    .cornerRadius(90)
                    .overlay(
                        RoundedRectangle(cornerRadius: 90)
                            .inset(by: 0.5)
                            .stroke(.black, lineWidth: 1)
                    )
                    .padding(.bottom, 16)
                    
>>>>>>> Stashed changes
                    
                    // Password input field
                    HStack {
<<<<<<< Updated upstream
                        Image(systemName: "lock.fill")  // Lock icon
                            .padding(.leading, 16)
                        SecureField("password", text: $password)  // Secure input for password
=======
                        Image(systemName: "lock.fill")
                            .padding(.leading, 30)
                        SecureField("Password", text: $password)
>>>>>>> Stashed changes
                            .font(.system(size: 20))
                            .padding()
                    }
                    .background(Color(red: 0.61, green: 0.54, blue: 0.72))
                    .cornerRadius(90)
                    .overlay(
                        RoundedRectangle(cornerRadius: 90)
                            .inset(by: 0.5)
                            .stroke(.black, lineWidth: 1))
                    .padding(.bottom, 16)
<<<<<<< Updated upstream

                    // Login button with Firebase authentication logic
=======
                    
                    
                    HStack {
                        Spacer()
                        Text("Sign in")
                            .font(.system(size: 20))
                            .foregroundColor(Color.white)
                            .padding(.trailing, 16)
                            .fontWeight(.semibold)
                            .underline()
                        Button(action: {
                            isCreateAccountViewPresented.toggle()
                        }) {
                            Text("Sign up")
                                .font(.system(size: 20))
                                .foregroundColor(.white.opacity(0.70))
                        }
                        .sheet(isPresented: $isCreateAccountViewPresented) {
                            NewAccountView()
                        }
                        Spacer()
                    }
                    .padding(.bottom, 30)
                    .padding(.top, 20)
                    
>>>>>>> Stashed changes
                    HStack {
                        Spacer()
                        Button(action: {
                            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                                if let error = error {
                                    print(error.localizedDescription)  // Print error description
                                    email = ""  // Clear email input
                                    password = ""  // Clear password input
                                    showErrorAlert.toggle()  // Show error alert
                                    return
                                }
                                if let authResult = authResult {
                                    let userId = authResult.user.uid  // Get user ID
                                    let db = Firestore.firestore()  // Reference to Firestore
                                    
                                    // Fetch user document from Firestore
                                    db.collection("users").document(userId).getDocument { document, error in
                                        if let document = document, document.exists {
                                            // Extract and set the username
                                            if let fetchedUsername = document.data()?["username"] as? String {
                                                self.username = fetchedUsername  // Bind username to state
                                                isPasswordCorrect = true  // Navigate to HouseView
                                            }
                                        } else {
                                            print("Document does not exist or could not fetch username")
                                        }
                                    }
                                }
                            }
                        }) {
<<<<<<< Updated upstream
                            // Login button icon
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 40))  // Set icon size
                                .foregroundColor(.blue)  // Set icon color
                                .padding(.top, 16)  // Padding above the icon
=======
                            Image("Enter Button")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 78, height: 94)
                                .padding(.top, 16)
>>>>>>> Stashed changes
                        }
                        .alert(isPresented: $showErrorAlert) {
                            Alert(title: Text("Login Error: Incorrect email or password"))  // Error alert
                        }
                        Spacer()
                    }
                    Spacer()  // Add space at the bottom
                }
<<<<<<< Updated upstream
                .padding()  // Add padding around the entire view
            }
            
            // Navigation to HouseView when the password is correct
            NavigationLink(destination: HouseView(username: $username).navigationBarBackButtonHidden(true), isActive: $isPasswordCorrect) {
                EmptyView()  // Use an empty view to trigger the navigation
=======
                
                .padding()
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.72, green: 0.75, blue: 0.87))
            
            NavigationLink(destination: HouseView(username: $username), isActive: $isPasswordCorrect) {
                EmptyView()
>>>>>>> Stashed changes
            }
            
        }
        
    }

}

// Preview for the LoginAppView
struct LoginAppView_Previews: PreviewProvider {
    static var previews: some View {
        LoginAppView()  // Preview the view in Xcode
    }
}
