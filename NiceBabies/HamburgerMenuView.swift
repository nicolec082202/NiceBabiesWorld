//
//  SwiftUIView.swift
//  NiceBabies
//
//  Created by Jordez Fernandez on 11/5/24.
//
import SwiftUI
import Firebase

struct HamburgerMenuView: View {
    @Binding var isMenuOpen: Bool
    var navigateToView: (String) -> Void
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                // Button 1
                Button(action: {
                    navigateToView("HouseView")
                    isMenuOpen.toggle()
                }) {
                    Text("-").padding()
                }
                
                // Button 2: House icon
                Button(action: {
                    navigateToView("HouseView")
                    isMenuOpen.toggle()
                }) {
                    Image("House")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding()
                }
                
                // Button 3: Laptop icon
                Button(action: {
                    navigateToView("GameCatalogView")
                    isMenuOpen.toggle()
                }) {
                    Image("Laptop")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding()
                }
                
                // Button 4: TeddyBear icon
                Button(action: {
                    navigateToView("DollStatusView")
                    isMenuOpen.toggle()
                }) {
                    Image("TeddyBear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding()
                }
                
                // Button 5: Closet icon
                Button(action: {
                    navigateToView("ClosetView")
                    isMenuOpen.toggle()
                }) {
                    Image("Closet")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding()
                }
                
                // Button 6: Exit Sign icon
                Button(action: {
                    navigateToView("LoginAppView")
                    isMenuOpen.toggle()
                }) {
                    Image("ExitSign")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.clear)
            .offset(x: isMenuOpen ? 0 : -UIScreen.main.bounds.width)
            .animation(.easeInOut(duration: 0.4), value: isMenuOpen)
        }
    }
}
