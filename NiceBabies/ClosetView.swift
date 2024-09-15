//
//  ClosetView.swift
//  NiceBabies
//
//  Created by Nicole Potter on 9/14/24.
//

import SwiftUI

struct ClosetView: View {
    var body: some View {

    VStack{

        
            HStack{
                
                Text("Collection")
                
                
                Image(systemName: "plus.circle")
                
                
                }
                .font(.system(size: 45))
                .position(x: 200, y: 70)
        
            
        
                        
            HStack{
                
                
                Image("NiceBaby_Fish")
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                
                Image("NiceBaby_Monkey")
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                Image("NiceBaby_Sheep")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            }
            
            Divider()
            .frame(width: 320, height: 10)
            .overlay(.black)
        
        HStack{
            
            
            Image("NiceBaby_Panda")
                .resizable()

            
            Image("NiceBaby_Rabbit")
                .resizable()

            Image("NiceBaby_Cow")
                .resizable()


            
            
        }
        
        Divider()
        .frame(width: 320, height: 10)
        .overlay(.black)
        
        
        Spacer()

            
        }
                    
            
        
        }
    }

struct ClosetView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView()
    }
}
