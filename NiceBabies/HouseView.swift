//
//  HouseView.swift
//  NiceBabies
//
//  Created by Nicole Potter on 7/8/24.
//

import SwiftUI

struct HouseView: View {
    
    @Binding var username:String
    
    var body: some View {
        
        NavBar(username: $username)
            
    }
}

struct HouseView_Previews: PreviewProvider {
    static var previews: some View {
        HouseView(username: .constant("The Baby"))
    }
}
