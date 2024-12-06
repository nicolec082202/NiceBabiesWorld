import SwiftUI
import FirebaseAuth  // Import FirebaseAuth for authentication services
import Firebase  // Import Firebase for Firestore database interaction

// Define the NewAccountView structure conforming to the View protocol
struct NewAccountView: View {
    
    // Access the presentation mode environment to dismiss the view
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""


    var body: some View {

        ZStack {
            
            VStack {
                
                HStack{
                    Image("Nice Babies Logo")
                        .resizable()
                        .frame(width: 250, height: 150)
                        .clipped()
                        .padding(.top, 70)
                        .padding(.bottom, 40)
                    
                }
                
                
                HStack {
                    Image(systemName: "person.fill")
                        .padding(.leading, 16)
                    TextField("Email", text: $email)
                        .font(.system(size: 20))
                    
                    
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
                
                HStack {
                    Image(systemName: "person.fill")
                        .padding(.leading, 16)
                    TextField("Username", text: $username)
                        .font(.system(size: 20))
                    if !username.isEmpty {
                        Image(systemName: username.isValidUserName() ? "checkmark" : "xmark")
                            .padding(.trailing, 16)
                            .foregroundColor(username.isValidUserName() ? .green : .red)
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
                
                HStack {
                    Image(systemName: "lock.fill")
                        .padding(.leading, 30)
                    SecureField("Password", text: $password)
                        .font(.system(size: 20))
                        .padding()
                }
                .background(Color(red: 0.61, green: 0.54, blue: 0.72))
                .cornerRadius(90)
                .overlay(
                    RoundedRectangle(cornerRadius: 90)
                        .inset(by: 0.5)
                        .stroke(.black, lineWidth: 1)
                )
                .padding(.bottom, 16)
                
                HStack{
                    Spacer()
                    Text("Sign in")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.70))
                        .padding(.trailing, 16)
                    Text("Sign up")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .underline()
                    
                    
                    Spacer()
                }
                .padding(.top, 16)
                
                
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("cancel")
                            .foregroundColor(.white.opacity(0.70))
                            .font(.system(size: 20))
                    }
                    .padding(.top, 16)
                    
                    Spacer()
                    Button(action: {
                        createAccount()
                        
                    }) {
                        Image("Enter Button")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 78, height: 94)
                            .padding(.top, 16)
                    }
                    .alert(isPresented: $showErrorAlert) {
                        Alert(title: Text("Error creating account"))
                    }
                    Spacer()
                    
                }
                
                Spacer()
                
            }
            .padding()
            

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.72, green: 0.75, blue: 0.87))
        
        
    }
    
    private func createAccount() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                errorMessage = error.localizedDescription
                showErrorAlert = true
                return
            }

            guard let userId = authResult?.user.uid else {
                errorMessage = "Unable to retrieve user ID."
                showErrorAlert = true
                return
            }

            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "email": email,
                "username": username,
                "equippedBaby": "NiceBaby_Monkey", // Default value
                "firstTimeLogin": true,            // Explicitly store as Boolean
                "foundEasterEgg": false,           // Explicitly store as Boolean
                "lastLoggedInTime": FieldValue.serverTimestamp(),
                "currentHearts": 5                 // Default value
            ]

            db.collection("users").document(userId).setData(userData) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                    errorMessage = "Failed to save user data: \(error.localizedDescription)"
                    showErrorAlert = true
                    return
                }

                print("User data saved successfully.")

                // Confirm user is logged in and navigate to HouseView
                if let currentUser = Auth.auth().currentUser {
                    print("User is logged in: \(currentUser.uid)")
                    presentationMode.wrappedValue.dismiss()
                } else {
                    errorMessage = "User is not logged in after account creation."
                    showErrorAlert = true
                }
            }
        }
    }
}




struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView()  // Display the view in preview mode
    }
}
