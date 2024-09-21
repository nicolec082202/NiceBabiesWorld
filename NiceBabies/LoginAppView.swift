import SwiftUI
import Firebase

struct LoginAppView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var username:String = ""


    @State private var isCreateAccountViewPresented = false
    @State private var isPasswordCorrect: Bool = false
    @State private var showErrorAlert: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Text("Nice Babies World")
                            .font(.system(size: 20))
                            .padding(.bottom, 16)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text("sign in")
                            .font(.system(size: 20))
                            .padding(.trailing, 16)
                            .fontWeight(.semibold)
                            .underline()
                        Button(action: {
                            isCreateAccountViewPresented.toggle()
                        }) {
                            Text("sign up")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                        .sheet(isPresented: $isCreateAccountViewPresented) {
                            NewAccountView()
                        }
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
                            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                                if let error = error {
                                    print(error.localizedDescription)
                                    email = ""
                                    password = ""
                                    showErrorAlert.toggle()
                                    return
                                }
                            if let authResult = authResult {
                                  let userId = authResult.user.uid
                                  let db = Firestore.firestore()
                                  
                                  db.collection("users").document(userId).getDocument { document, error in
                                      if let document = document, document.exists {
                                          // Safely extract the username from the document
                                          if let fetchedUsername = document.data()?["username"] as? String {
                                              self.username = fetchedUsername // Set the binding
                                              isPasswordCorrect = true // Navigate to HouseView
                                          }
                                      } else {
                                          print("Document does not exist or could not fetch username")
                                      }
                                    }
                                }
                                
                            }
                        }) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                                .padding(.top, 16)
                        }
                        .alert(isPresented: $showErrorAlert) {
                            Alert(title: Text("Login Error: Incorrect email or password"))
                        }
                        Spacer()
                    }
                    
                    
                    
                    Spacer()
                }
                .padding()
            }
            NavigationLink(destination: HouseView(username: $username), isActive: $isPasswordCorrect) {
                EmptyView()
            }
        }
    }
}

struct LoginAppView_Previews: PreviewProvider {
    static var previews: some View {
        LoginAppView()
    }
}
