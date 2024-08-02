//
//  HomePageView.swift
//  NiceBabies
//
//  Created by Nicole Potter on 7/5/24.
//

import SwiftUI

struct HomePageView: View {
    
    @Binding var username:String

    
    var body: some View {
        
       // NavigationView{
                    
            VStack{
                
                Spacer()
                
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
                
                Spacer()
                
                HStack{
                    Image(systemName: "figure.stand")
                        .font(.system(size: 450))
                    
                    
                }
                
                Spacer()
                
                NavBar(username: $username)
                
                
            }
            
        }
   // }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        

        HomePageView(username: .constant("thebaby"))
    }
}
