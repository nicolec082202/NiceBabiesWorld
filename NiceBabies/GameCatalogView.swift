//
//  GameCatalogView.swift
//  NiceBabies
//
//  Created by Nicole Potter on 7/8/24.
//

import SwiftUI

struct GameCatalogView: View {
    
    @Binding var username:String

    var body: some View {
        NavBar(username: $username)
    }
}

struct GameCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        GameCatalogView(username: .constant("The Baby"))
    }
}
