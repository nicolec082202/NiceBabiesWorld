import SwiftUI
import FirebaseAuth  // Import FirebaseAuth for authentication services
import Firebase  // Import Firebase for Firestore database interaction

// Define the NewAccountView structure conforming to the View protocol
struct NewAccountView: View {
    
    // Access the presentation mode environment to dismiss the view
    @Environment(\.presentationMode) var presentationMode
    
    // State variables to store input values and manage alerts
    @State private var email: String = ""  // User's email input
    @State private var password: String = ""  // User's password input
    @State private var username: String = ""  // User's chosen username
    @State private var showErrorAlert: Bool = false  // Show alert on error
    @State private var errorMessage: String = ""  // Store error message for alerts

    var body: some View {
        ZStack {
            VStack {
                Spacer()  // Add space at the top
                
                // App title
                Text("Nice Babies World")
                    .font(.system(size: 20))  // Set font size
                    .padding(.bottom, 50)  // Add padding below the title
                
                // Horizontal stack for "sign in" and "sign up" options
                HStack {
                    Spacer()
                    Text("sign in")
                        .font(.system(size: 20))  // Set font size for sign-in text
                        .padding(.trailing, 16)  // Add right padding
                    Text("sign up")
                        .font(.system(size: 20))  // Set font size for sign-up text
                        .fontWeight(.semibold)  // Make the text semibold
                        .underline()  // Underline the text
                    Spacer()
                }
                .padding(.bottom, 32)  // Add padding below the section
                
                // Email input field with validation
                HStack {
                    Image(systemName: "person.fill")  // Person icon
                        .padding(.leading, 16)
                    TextField("email", text: $email)  // Text field for email input
                        .font(.system(size: 20))
                    // Display checkmark or crossmark based on email validity
                    if !email.isEmpty {
                        Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                            .padding(.trailing, 16)
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                    }
                }
                .padding()
                .background(Color(red: 0.16, green: 0.5, blue: 0.9).opacity(0.2))  // Background color
                .cornerRadius(90)  // Rounded corners
                .padding(.bottom, 16)  // Add bottom padding

                // Username input field with validation
                HStack {
                    Image(systemName: "person.fill")  // Person icon
                        .padding(.leading, 16)
                    TextField("username", text: $username)  // Text field for username input
                        .font(.system(size: 20))
                    // Display checkmark or crossmark based on username validity
                    if !username.isEmpty {
                        Image(systemName: username.isValidUserName() ? "checkmark" : "xmark")
                            .padding(.trailing, 16)
                            .foregroundColor(username.isValidUserName() ? .green : .red)
                    }
                }
                .padding()
                .background(Color(red: 0.16, green: 0.5, blue: 0.9).opacity(0.2))
                .cornerRadius(90)
                .padding(.bottom, 16)

                // Password input field
                HStack {
                    Image(systemName: "lock.fill")  // Lock icon
                        .padding(.leading, 16)
                    SecureField("password", text: $password)  // Secure text field for password input
                        .font(.system(size: 20))
                        .padding()
                }
                .background(Color(red: 0.16, green: 0.5, blue: 0.9).opacity(0.2))
                .cornerRadius(90)
                .padding(.bottom, 16)

                // Horizontal stack for "cancel" and "create account" buttons
                HStack {
                    Spacer()
                    // Cancel button to dismiss the view
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()  // Dismiss the view
                    }) {
                        Text("cancel")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                    }
                    .padding(.top, 16)

                    Spacer()

                    // Create account button with Firebase authentication logic
                    Button(action: {
                        // Create a new user with the given email and password
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if let error = error {  // Handle error
                                print(error.localizedDescription)  // Print error to console
                                return
                            }
                            if let authResult = authResult {  // If user creation is successful
                                print("\(authResult.user.uid)")  // Print user ID to console

                                // Save user data to Firestore
                                let db = Firestore.firestore()
                                db.collection("users").document(authResult.user.uid).setData([
                                    "email": email,
                                    "username": username
                                ]) { error in
                                    if let error = error {  // Handle Firestore error
                                        print("Error adding document: \(error)")
                                        self.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                                        self.showErrorAlert = true  // Show alert on error
                                    } else {
                                        print("Document added with ID: \(authResult.user.uid)")
                                        presentationMode.wrappedValue.dismiss()  // Dismiss the view on success
                                    }
                                }
                            }
                        }
                    }) {
                        Image(systemName: "arrow.right.circle.fill")  // Arrow icon for the button
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                            .padding(.top, 16)
                    }
                    .alert(isPresented: $showErrorAlert) {  // Show alert on error
                        Alert(title: Text("Error creating account"))  // Alert message
                    }
                    Spacer()
                }
                
                Spacer()  // Add space at the bottom
            }
            .padding()  // Add padding around the VStack
        }
    }
}

// Preview of NewAccountView for development in Xcode
struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView()  // Display the view in preview mode
    }
}
