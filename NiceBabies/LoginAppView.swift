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
                    Spacer()  // Add space at the top
                    
                
                    HStack{
                        Image("Nice Babies Logo")
                            .resizable()
                            .frame(width: 250, height: 150)
                            .clipped()
                            .padding(.top, 70)
                            .padding(.bottom, 40)
                    }
                        
                   
                    
                    // Email input field with validation
                    HStack {
                        Image(systemName: "person.fill")  // Person icon
                            .padding(.leading, 16)
                        TextField("Email", text: $email)
                            .font(.system(size: 20))
                        
                        // Show checkmark or crossmark based on email validity
                        if !email.isEmpty {
                            Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                                .padding(.trailing, 16)
                                .foregroundColor(email.isValidEmail() ? .green : .red)
                        }
                    }
                    .padding()
                    .background(Color(red: 0.61, green: 0.54, blue: 0.72))
                    .cornerRadius(90)
                    .overlay(
                        RoundedRectangle(cornerRadius: 90)
                            .inset(by: 0.5)
                            .stroke(.black, lineWidth: 1)
                    )
                    .padding(.bottom, 16)
                    
                    
                    // Password input field
                    HStack {
                        Image(systemName: "lock.fill")  // Lock icon
                            .padding(.leading, 16)
                        SecureField("Password", text: $password)
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

                    // Login button with Firebase authentication logic
                    
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

                            Image("Enter Button")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 78, height: 94)
                                .padding(.top, 16)
                        }
                        .alert(isPresented: $showErrorAlert) {
                            Alert(title: Text("Login Error: Incorrect email or password"))  // Error alert
                        }
                        Spacer()
                    }
                    Spacer()  // Add space at the bottom
                }
                .padding()  // Add padding around the entire view
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.72, green: 0.75, blue: 0.87))
            
            // Navigation to HouseView when the password is correct
            NavigationLink(destination: HouseView(username: $username).navigationBarBackButtonHidden(true), isActive: $isPasswordCorrect) {
                EmptyView()  // Use an empty view to trigger the navigation
                
                .padding()
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
