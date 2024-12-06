import SwiftUI
import Firebase

struct HamburgerMenuView: View {
    @State var isMenuOpen: Bool
    @Binding var username: String
    @Binding var equippedBaby: String
    @Binding var gameCompleted: Bool
    @State private var navigateToLogIn = false // State to trigger navigation
    @State var currentView: String = ""// Current view identifier passed in
    

    var body: some View {
        
         let menuItems: [MenuItem] = [
            MenuItem(viewName: "HouseView", imageName: "HamburgerMenu_Home", destination: AnyView(HouseView(username: $username, gameCompleted: $gameCompleted)), action: nil),
            MenuItem(viewName: "GameCatalogView", imageName: "HamburgerMenu_Laptop", destination: AnyView(GameCatalogView(equippedBaby: $equippedBaby, username: $username, gameCompleted: $gameCompleted)), action: nil),
            MenuItem(viewName: "DollStatusView", imageName: "HamburgerMenu_Doll", destination: AnyView(DollStatusView(username: $username, equippedBaby: $equippedBaby, gameCompleted: $gameCompleted)), action: nil),
            MenuItem(viewName: "Logout", imageName: "HamburgerMenu_Logout", destination: AnyView(LoginAppView()), action: {self.signOutUser()})
        ]
        
        
        VStack() {
            // Triple bars at the top that do not move
            HStack() {
                Image(systemName: "line.horizontal.3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .padding()
                    .background(Circle().fill(Color(red: 240/255, green: 239/255, blue: 209/255)))
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            isMenuOpen.toggle()
                        }
                    }
                

            // Animated accordion menu

                ForEach(menuItems.indices, id: \.self) { index in
                    let item = menuItems[index]
                    itemView(for: item)
                        .opacity(isMenuOpen ? 1 : 0)
                        .offset(x: isMenuOpen ? 0 : -20)
                        .animation(.easeInOut(duration: 0.6).delay(Double(index) * 0.1), value: isMenuOpen)
                        .disabled(item.viewName == currentView) // Disable interaction if it's the current view
                }
                
            }
            .padding(.top, 7)
            .padding(.trailing, 50)

            


            
            Spacer()
        }
       // .background(Color.clear)
        
        NavigationLink(destination: LoginAppView().navigationBarBackButtonHidden(true), isActive: $navigateToLogIn) {
            EmptyView()
        }
    }

    private func itemView(for item: MenuItem) -> some View {
        Group {
            if let action = item.action {
                Button(action: action) {
                    Image(item.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding(.leading, 0)
                }
            } else {
                NavigationLink(destination: item.destination.navigationBarBackButtonHidden(true)) {
                    Image(item.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding(.leading, 5)
                }
                .disabled(item.viewName == currentView) // Prevent navigation if it's the current view
            }
        }
    }
    
    func signOutUser() {
            do {
                try Auth.auth().signOut() // Firebase sign out
                navigateToLogIn = true // Trigger navigation
                print("user logged out")
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError.localizedDescription)")
            }
        }
}

    

struct MenuItem {
    let viewName: String // Add a view identifier
    let imageName: String
    let destination: AnyView
    let action: (() -> Void)?
}


struct HamburgerMenuView_Previews: PreviewProvider {
    static var previews: some View {
        HamburgerMenuView(isMenuOpen: true, username: .constant("TheBaby"), equippedBaby: .constant("NiceBaby_Monkey"), gameCompleted: .constant(false))
    }
}
