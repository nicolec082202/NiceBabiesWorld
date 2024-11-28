import SwiftUI
import WidgetKit

struct DollStatusView: View {
    @Binding var username: String
    @State private var currentIndex = 0
    @Binding var equippedBaby: String
    @State private var hearts: Double = {
         let defaults = UserDefaults(suiteName: "group.nicebabies") ?? UserDefaults.standard
         return defaults.double(forKey: "hearts") == 0 ? 5.0 : defaults.double(forKey: "hearts")
     }() //adding suitename belonging to app group capability
    @State private var workoutGameCompleted = false

    @Environment(\.presentationMode) var isDollStatusViewPresented

    var body: some View {
        
        NavigationView{
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                
                ZStack {
                    
                    HamburgerMenuView(isMenuOpen: false, username: $username, equippedBaby: $equippedBaby, currentView: "DollStatusView")
                    // Button to dismiss the view
                   
                    
                    // Vertical stack for username and hearts
                    VStack {
                        Text("@" + username)
                            .font(.system(size: width * 0.08)) // Font size relative to width
                        
                        // Row of heart icons
                        HStack {
                            ForEach(0..<5) { index in
                                if Double(index) < hearts {
                                    if hearts - Double(index) > 0.5 {
                                        Image("full_heart")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: width * 0.1, height: height * 0.1) // Size relative to view dimensions
                                    } else {
                                        Image("half_heart")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: width * 0.1, height: height * 0.1) // Size relative to view dimensions
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: width * 0.4) // Adjust container size relative to width
                    .position(x: width * 0.5, y: height * 0.2) // Centered relatively
                    
                    // Display the equipped baby/doll image
                    VStack {
                        Image(equippedBaby)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width * 2, height: height * 1.3) // Adjust size relative to view dimensions
                    }
                    .zIndex(-1.0)
                    .position(x: width * 0.53, y: height * 0.6) // Centered relatively
                }
                .onAppear(perform: checkInactivity)
                .background(Image("HomePage Background")
                    .resizable()
                    .ignoresSafeArea()
                    .frame(width: width*1.59, height: height)
                    .blur(radius: 5, opaque: true))
                
            }
        }

    }

    func checkInactivity() {
        let defaults = UserDefaults(suiteName: "group.nicebabies") ?? UserDefaults.standard

        if let lastActiveDate = UserDefaults.standard.object(forKey: "lastActiveDate") as? Date {
            let hourElapsed = Date().timeIntervalSince(lastActiveDate) / 3600
            let heartsLost = hourElapsed / 6 / 2
            hearts = max(hearts - heartsLost, 0)
        } else {
            defaults.set(Date(), forKey: "lastActiveDate")
        }
        // Add this to your DollStatusView or wherever you modify hearts
        defaults.set(hearts, forKey: "hearts")
        defaults.set(Date(), forKey: "lastActiveDate")
        defaults.synchronize()
        WidgetCenter.shared.reloadAllTimelines()
    }

    func updateHearts() {
        let defaults = UserDefaults(suiteName: "group.nicebabies") ?? UserDefaults.standard

        if workoutGameCompleted {
            hearts = min(hearts + 1, 5)
            workoutGameCompleted = false
            
            defaults.set(hearts, forKey: "hearts")
            defaults.synchronize()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

// Preview for the DollStatusView
struct DollStatusView_Previews: PreviewProvider {
    static var previews: some View {
        DollStatusView(username: .constant("thebaby"), equippedBaby: .constant("NiceBaby_Monkey"))
    }
}
