//
//  GameCatalogView.swift
//  NiceBabies
//
//  Created by Nicole Potter on 7/8/24.
//

import SwiftUI

struct GameCatalogView: View {
    
    @Environment(\.presentationMode) var isGameCatalogViewPresented
    

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
                
            }
            
        }
    }


struct GameCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        GameCatalogView()
    }
}
