//
//  HomePageView.swift
//  NiceBabies
//
//  Created by Nicole Potter on 7/5/24.
//

import SwiftUI

struct HomePageView: View {
    
    @Binding var username:String
    @State private var isHousePresented = false
    @State private var isClubPresented = false
    @State private var isGameCatalogPresented = false

    
    var body: some View {
        
       // NavigationView{
            
            VStack{
                Text("@" + username)
                    .font(.system(size: 30))
                    .padding(.trailing, 235)
                
                HStack{
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 35))
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 35))
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 35))
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 35))
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 35))
                    
                }
                .padding(.trailing, 125)
                
                HStack{
                    Image(systemName: "figure.stand")
                        .font(.system(size: 450))
                    
                   /* NavigationLink(destination: HouseView()){
                        
                        Image(systemName: "house.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 35))
                    }*/
                    
                    VStack{
                        
                        Button(action: {
                            isHousePresented.toggle()
                        }) {
                            Image(systemName: "house.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 35))
                        }
                        .fullScreenCover(isPresented: $isHousePresented){
                            HouseView()
                        }
                        
                        Button(action: {
                            isClubPresented.toggle()
                        }) {
                            Image(systemName: "opticaldisc.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 35))
                        }
                        .fullScreenCover(isPresented: $isClubPresented){
                            ClubView()
                        }
                        
                        
                    }
                    
                }
                
                
            }
            
        }
   // }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        

        HomePageView(username: .constant("thebaby"))
    }
}
