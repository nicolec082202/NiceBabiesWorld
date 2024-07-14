import SwiftUI
import FirebaseAuth
import Firebase


struct NewAccountView: View {
    @Environment(\.presentationMode)
    var presentationMode
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var showErrorAlert: Bool = false



    var body: some View {
            ZStack {
                VStack {
                    Spacer()
                   
                    Text("Nice Babies World")
                        .font(.system(size: 20))
                        .padding(.bottom, 50)
                    
                    HStack{
                        Spacer()
                        Text("sign in")
                            .font(.system(size: 20))
                            .padding(.trailing, 16)
                        Text("sign up")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .underline()
                        Spacer()
                    }
                    .padding(.bottom, 32)
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .padding(.leading, 16)
                        TextField("email", text: $email)
                            .font(.system(size: 20))
                        if !email.isEmpty {
                            Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                                .padding(.trailing, 16)
                                .foregroundColor(email.isValidEmail() ? .green : .red)
                        }
                    }
                    .padding()
                    .background(Color(red: 0.16, green: 0.5, blue: 0.9).opacity(0.2))
                    .cornerRadius(90)
                    .padding(.bottom, 16)
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .padding(.leading, 16)
                        TextField("username", text: $username)
                            .font(.system(size: 20))
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
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .padding(.leading, 16)
                        SecureField("password", text: $password)
                            .font(.system(size: 20))
                            .padding()
                    }
                    .background(Color(red: 0.16, green: 0.5, blue: 0.9).opacity(0.2))
                    .cornerRadius(90)
                    .padding(.bottom, 16)
                    
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("cancel")
                                .foregroundColor(.blue)
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
                                        "username": username,
                                        "email": email
                                    ]) { error in
                                        if let error = error {
                                            print("Error adding  document: \(error)")
                                        } else {
                                            print("Document added with ID: \(authResult.user.uid)")
                                        }
                                    }
                                }
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
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
    }
}


struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView()
    }
}
