import SwiftUI

struct GameCatalogView: View {
    @Environment(\.presentationMode) var isGameCatalogViewPresented
    @State private var isWorkoutGamePresented = false
    @State private var isMatchingGamePresented = false
    @State private var isFlappyGamePresented = false

    var body: some View {
        NavigationView { // Ensure GameCatalogView itself has a NavigationView context
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                
                ZStack {
                    
                    
                    Color(red: 0, green: 0, blue: 0)
                        .edgesIgnoringSafeArea(.all)


                    
                    Image("Cat")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width*1.5, height: height*1.5)
                        .position(x: width*0.7, y: height*0.2)
                    
                    Image("Game Select Icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width*0.7, height: height*1.4)
                        .position(x: width*0.5, y: height*0.27)
                


                    Spacer()
                    
                    VStack{

                        HStack{
                            
                            
                            Button(action: {
                                isFlappyGamePresented = true
                            }) {
                                Image("Flappy Bird Game Button Icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(10)
                            }
                            .fullScreenCover(isPresented: $isFlappyGamePresented) {
                                SpriteKitView(gameType: .flappy)
                                    .edgesIgnoringSafeArea(.all)
                            }
                            
                            
                            
                            Button(action: {
                                isMatchingGamePresented = true
                            }) {
                                Image("Matching Game Button Icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(10)
                            }
                            .fullScreenCover(isPresented: $isMatchingGamePresented) {
                                SpriteKitView( gameType: .matching)
                                    .edgesIgnoringSafeArea(.all)
                            }
                            
                        }
                        
                        
                        
                    }
                    .frame(width: width, height: height)
                    .position(x: width*0.5, y: height*0.6)
                    
                    HamburgerMenuView(isMenuOpen: false, currentView: "GameCatalogView")


                }
            }
            .navigationBarHidden(true) // Hide navigation bar if not needed
        }
    }
}


// Preview of the GameCatalogView for development in Xcode
struct GameCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        GameCatalogView()
    }
}
