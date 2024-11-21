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
    @State private var isClosetViewPresented = false
    @State private var isLoginAppViewPresented = false
    @State private var equippedBaby = "NiceBaby_Monkey"
    @State private var isMenuOpen = false
    @State private var currentView = "HouseView"
    @State private var showTutorial = false
    @AppStorage("firstTimeLogin") private var firstTimeLogin: Bool = true
    @State private var currentTutorialStep = 0
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
            
            // Hamburger Menu
            HamburgerMenuView(isMenuOpen: $isMenuOpen) { viewName in
                navigateTo(viewName: viewName)
            }
            
            // Hamberger Menu button
            VStack {
                           HStack {
                               Button(action: {
                                   isMenuOpen.toggle()
                               }) {
                                   Image(systemName: "line.horizontal.3")
                                       .font(.system(size: 30))
                                       .padding()
                               }
                               Spacer()
                           }
                           Spacer()
                       }
                       
                       // Show the tutorial if it's the first time login
                       if firstTimeLogin && showTutorial {
                           TutorialView(showTutorial: $showTutorial, currentTutorialStep: $currentTutorialStep)
                               .transition(.opacity)
                       }
                       
                   }
                   .onAppear {
                       if firstTimeLogin {
                           showTutorial = true
                           // Optionally set firstTimeLogin to false to prevent showing the tutorial again
                           // firstTimeLogin = false
                       }
                   }
                   .fullScreenCover(isPresented: $isClosetViewPresented) {
                       ClosetView() // Implement ClosetView
                   }
                   .fullScreenCover(isPresented: $isLoginAppViewPresented) {
                       LoginAppView() // Implement LoginAppView
                   }
               }
               
               // Navigation Logic of Hamburger Menu
               private func navigateTo(viewName: String) {
                   switch viewName {
                   case "GameCatalogView":
                       isGameCatalogViewPresented = true
                   case "DollStatusView":
                       isDollStatusViewPresented = true
                   case "ClosetView":
                       isClosetViewPresented = true
                   case "LoginAppView":
                       isLoginAppViewPresented = true
                   default:
                       break
                   }
               }
           }

           struct HouseView_Previews: PreviewProvider {
               static var previews: some View {
                   HouseView(username: .constant("thebaby"))
               }
           }
