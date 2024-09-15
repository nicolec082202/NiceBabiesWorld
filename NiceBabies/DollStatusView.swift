//
//  HomePageView.swift
//  NiceBabies
//
//  Created by Nicole Potter on 7/5/24.
//

import SwiftUI

struct DollStatusView: View {
    
    @Binding var username:String
    @State private var currentIndex = 0
    @Binding var equippedBaby:String
    @Environment(\.presentationMode) var isDollStatusViewPresented
    
    var body: some View {
                    
        ZStack(){
                        

        
                Button(action: {
                    isDollStatusViewPresented.wrappedValue.dismiss()
                }) {
                    
                    Image(systemName: "house.fill")
                        .font(.system(size: 25))
                        .foregroundColor(Color.black)
                    }
                    .position(x: 50, y: 10)
            
                    
            VStack{

                
                Text("@" + username)
                    .font(.system(size: 30))
                
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
                
                }
                .frame(width: 135, height: 5)
                .position(x: 200, y: 150)

  

                
            VStack {
                    
                    Image(equippedBaby)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 800, height: 1000)
                    
                }
                .zIndex(-1.0)
                .position(x: 200, y: 400)
                



          //  }
                
        }
            
    }
}



struct DollStatusView_Previews: PreviewProvider {
    static var previews: some View {
        

        DollStatusView(username: .constant("thebaby"), equippedBaby: .constant("NiceBaby_Monkey"))
    }
}
