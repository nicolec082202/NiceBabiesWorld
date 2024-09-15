//
//  HouseView.swift
//  NiceBabies
//
//  Created by Nicole Potter on 7/8/24.
//

import SwiftUI

struct HouseView: View {
    
    @State private var isGameCatalogViewPresented = false
    @State private var isDollStatusViewPresented = false
    @State private var equippedBaby = "NiceBaby_Monkey"
    
    @Binding var username:String

    var body: some View {
        
        
        ZStack(){
            
            
            Image(systemName: "window.horizontal.closed")
                .font(.system(size: 100))
                .position(x: 200, y: 175)
            
            Button(action: {
                isGameCatalogViewPresented = true
            }) {
                Image(systemName: "play.laptopcomputer")
                    .font(.system(size: 70))
                    .foregroundColor(Color.black)
                
            }
            .frame(width: 60, height: 50)
            .contentShape(Rectangle())
            .position(x: 70, y: 355)
            .fullScreenCover(isPresented: $isGameCatalogViewPresented) {
                GameCatalogView()
            }
            
            Image(systemName: "table.furniture.fill")
                .font(.system(size: 100))
                .position(x: 70, y: 425)
            
            
            Image(systemName: "bed.double.fill")
                .font(.system(size: 95))
                .position(x: 320, y: 425)
            
                
                Button(action: {
                    isDollStatusViewPresented = true
                }) {
                    Image(equippedBaby)
                    //Allow image to be resized
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 550)
                    
                }

                //controls frame of button
                //to ensure you cannot click outside of the bounds
                .frame(width: 135, height: 175)
                //of the image
                .contentShape(Rectangle()) // Make only the clipped shape clickable
                .position(x: 200, y: 520)
                .fullScreenCover(isPresented: $isDollStatusViewPresented) {
                    DollStatusView(username: $username, equippedBaby: $equippedBaby)
                }
                
            
        }

    }
    
}

struct HouseView_Previews: PreviewProvider {
    static var previews: some View {
        HouseView(username: .constant("thebaby"))
    }
}
