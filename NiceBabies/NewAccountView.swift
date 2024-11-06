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
                                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                        return
                                    }
                                    if let authResult = authResult {
                                        print("\(authResult.user.uid)")
                                        
                                        let db = Firestore.firestore()
                                        db.collection("users").document(authResult.user.uid).setData([
                                            "email": email,
                                            "username": username
                                        ]) { error in
                                            if let error = error {
                                                print("Error adding document: \(error)")
                                                self.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                                                self.showErrorAlert = true
                                            } else {
                                                print("Document added with ID: \(authResult.user.uid)")
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                        }
                                    }
                                    presentationMode.wrappedValue.dismiss()
                                }
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
    
}


struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView()  // Display the view in preview mode
    }
}
