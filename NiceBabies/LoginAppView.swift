import SwiftUI
import Firebase

struct LoginAppView: View {
    @State var email: String = ""
    @State var password: String = ""

    @State private var isCreateAccountViewPresented = false
    @State private var isPasswordCorrect: Bool = false
    @State private var showErrorAlert: Bool = false
    @Binding var username:String

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    WelcomeTextLogIn()
                    SignInOptions(isCreateAccountViewPresented: $isCreateAccountViewPresented)
                    EmailTextFieldLogIn(email: $email)
                    PasswordTextFieldLogIn(password: $password)
                    LoginButtons(email: $email, password: $password, isPasswordCorrect: $isPasswordCorrect, showErrorAlert: $showErrorAlert)
                    Spacer()
                }
                .padding()
            }
            NavigationLink(destination: HomePageView(username: $username), isActive: $isPasswordCorrect) {
                EmptyView()
            }
        }
    }
}

struct WelcomeTextLogIn: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Nice Babies World")
                .font(.system(size: 20))
                .padding(.bottom, 16)
            Spacer()
        }
    }
}

struct SignInOptions: View {
    @Binding var isCreateAccountViewPresented: Bool

    var body: some View {
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
    }
}

struct EmailTextFieldLogIn: View {
    @Binding var email: String

    var body: some View {
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
    }
}

struct PasswordTextFieldLogIn: View {
    @Binding var password: String

    var body: some View {
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
    }
}

struct LoginButtons: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var isPasswordCorrect: Bool
    @Binding var showErrorAlert: Bool

    var body: some View {
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
                    if let _ = authResult {
                        isPasswordCorrect = true
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
    }
}

struct LoginAppView_Previews: PreviewProvider {
    static var previews: some View {
        LoginAppView(username: .constant("thebaby"))
    }
}
