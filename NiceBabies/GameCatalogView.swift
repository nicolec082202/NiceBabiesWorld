import SwiftUI

struct GameCatalogView: View {
    @Environment(\.presentationMode) var isGameCatalogViewPresented
    @State private var isWorkoutGamePresented = false
    @State private var isMatchingGamePresented = false
    @Binding var equippedBaby: String
    @Binding var username: String

    var body: some View {
        
        //Color.purple
        
        NavigationView { // Ensure GameCatalogView itself has a NavigationView context
            
            
            
            ZStack{
                
                Color(red: 0.8, green: 0.6, blue: 0.9)
                    .edgesIgnoringSafeArea(.all)
                
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    Image("Game Select Icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        //.frame(width: 90)
                        .padding(.bottom, 350)
                    
                    
                    
                    
                    Image(equippedBaby)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        //.frame(width: width * 0.7, height: height * 0.7) // Set frame size relative to view dimensions
                        .padding(.top, 40)
                    
                    
                    ZStack {
                        HamburgerMenuView(isMenuOpen: false, username: $username, equippedBaby: $equippedBaby, currentView: "GameCatalogView")
                        
                        /*
                        Text("Game Catalog View")
                            .font(.title)
                            .position(x: width * 0.5, y: height * 0.1)
                         
                         
                        
                        Image("Game Select Icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            //.frame(width: 120)
                        */
                        
                        VStack(spacing: height * 0.02) {
                            
                            Spacer()
                            
                            
                            HStack{
                                
                                
                                Button(action: {
                                    isWorkoutGamePresented = true
                                }) {
                                    Image("WorkOutGame Button Icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 150, height: 150)
                                    //.padding()
                                    //.background(Color.green)
                                        .cornerRadius(10)
                                }
                                .fullScreenCover(isPresented: $isWorkoutGamePresented) {
                                    SpriteKitView(equippedBaby: $equippedBaby, gameType: .workout)
                                        .edgesIgnoringSafeArea(.all)
                                }
                                
                                
                                /*
                                 label: {
                                 Image("WorkOutGame Button Icon")
                                 .resizable()
                                 .aspectRatio(contentMode: .fit)
                                 .frame(width: 120)
                                 }
                                 */
                                
                                Button(action: {
                                    isMatchingGamePresented = true
                                }) {
                                    Image("Matching Game Button Icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 150, height: 150)
                                    //.padding()
                                    //.background(Color.green)
                                        .cornerRadius(10)
                                }
                                .fullScreenCover(isPresented: $isMatchingGamePresented) {
                                    SpriteKitView(equippedBaby: $equippedBaby, gameType: .matching)
                                        .edgesIgnoringSafeArea(.all)
                                }
                                
                                
                            }
                            
                            
                        }
                        .frame(width: width, height: height)
                        .position(x: width * 0.5, y: height * 0.5)
                    }
                }
                .navigationBarHidden(true) // Hide navigation bar if not needed
            }
        }
    }
}


// Preview of the GameCatalogView for development in Xcode
struct GameCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        GameCatalogView(equippedBaby:.constant("NiceBaby_Monkey"), username: .constant("TheBaby"))
    }
}
