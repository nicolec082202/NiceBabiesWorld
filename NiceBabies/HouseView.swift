//
//  HouseView.swift
//  NiceBabies
//
//  Created by Nicole Potter on 7/8/24.
//

import SwiftUI

struct HouseView: View {
    
    var body: some View {
        
        @Environment(\.presentationMode)
        var presentationMode
        
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "house.fill")
                .foregroundColor(.black)
                .font(.system(size: 20))
        }
            
        
        
        
    }
}

struct HouseView_Previews: PreviewProvider {
    static var previews: some View {
        HouseView()
    }
}
