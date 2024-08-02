//
//  NavBar.swift
//  NiceBabies
//
//  Created by Nicole Potter on 7/27/24.
//

import SwiftUI

struct NavBar: View {
    
    @State private var isHomePresented = false
    @State private var isHousePresented = false
    @State private var isGameCatalogPresented = false
    @Binding var username:String

    var body: some View {
        
    
        HStack{
            
            Spacer()
            
            
            Button(action: {
                isHomePresented.toggle()
            }) {
                Image(systemName: "person.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 35))
            }
            .fullScreenCover(isPresented: $isHomePresented){
                HomePageView(username: $username)
            }
            
            Spacer()
            
            
            Button(action: {
                isHousePresented.toggle()
            }) {
                Image(systemName: "house.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 35))
            }
            .fullScreenCover(isPresented: $isHousePresented){
                HouseView(username: $username)
            }
            
            Spacer()
            
            Button(action: {
                isGameCatalogPresented.toggle()
            }) {
                Image(systemName: "opticaldisc.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 35))
            }
            .fullScreenCover(isPresented: $isGameCatalogPresented){
                GameCatalogView(username: $username)
            }
            
            Spacer()
            
        }
    }
}

struct NavBar_Previews: PreviewProvider {
    

    static var previews: some View {
        NavBar(username: .constant("The Baby"))
    }
}
