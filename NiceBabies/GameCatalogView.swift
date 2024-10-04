//
//  GameCatalogView.swift
//  NiceBabies
//
//  Created by Nicole Potter on 7/8/24.
//

import SwiftUI

struct GameCatalogView: View {
    
    @Environment(\.presentationMode) var isGameCatalogViewPresented
    @State private var isGamePresented = false

    

    var body: some View {
        
        ZStack{
            
            Button(action: {
                isGameCatalogViewPresented.wrappedValue.dismiss()
            }) {
                
                Image(systemName: "house.fill")
                    .font(.system(size: 25))
                    .foregroundColor(Color.black)
                
            }
            .position(x: 50, y: 10)

            
            Text("Game Catalog View")
                .position(x: 200, y: 30)
            
            Button(action: {
                            isGamePresented = true
                        }) {
                            Text("Play Mini-Game")
                                .font(.title)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .fullScreenCover(isPresented: $isGamePresented) {
                            GameView(isGamePresented: $isGamePresented)
                }
                
            }
            
        }
    }

struct GameView: View {
    @Binding var isGamePresented: Bool
    
    var body: some View {
        SpriteKitView() // This is your SpriteKit game
            .overlay(
                Button(action: {
                    isGamePresented = false // Dismiss the game and return to the main view
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 40))
                        .padding()
                        .foregroundColor(.white)
                }
                .position(x: UIScreen.main.bounds.width - 50, y: 50), alignment: .topTrailing
            )
    }
}

struct GameCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        GameCatalogView()
    }
}
