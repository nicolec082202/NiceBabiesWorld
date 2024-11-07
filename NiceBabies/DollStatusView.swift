import SwiftUI

struct DollStatusView: View {
    @Binding var username: String
    @State private var currentIndex = 0
    @Binding var equippedBaby: String
    
    @State private var hearts: Double = UserDefaults.standard.double(forKey: "hearts") == 0 ? 5.0 : UserDefaults.standard.double(forKey: "hearts")
    @State private var workoutGameCompleted = false

    @Environment(\.presentationMode) var isDollStatusViewPresented

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            ZStack {
                // Button to dismiss the view
                Button(action: {
                    isDollStatusViewPresented.wrappedValue.dismiss()
                }) {
                    Image(systemName: "house.fill")
                        .font(.system(size: width * 0.05)) // Adjust font size relative to width
                        .foregroundColor(Color.black)
                }
                .position(x: width * 0.1, y: height * 0.01) // Position relative to view size

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
            .background(Image("closetBackground")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 5, opaque: true))

        }

    }

    func checkInactivity() {
        if let lastActiveDate = UserDefaults.standard.object(forKey: "lastActiveDate") as? Date {
            let hourElapsed = Date().timeIntervalSince(lastActiveDate) / 3600
            let heartsLost = hourElapsed / 6 / 2
            hearts = max(hearts - heartsLost, 0)
        } else {
            UserDefaults.standard.set(Date(), forKey: "lastActiveDate")
        }
        UserDefaults.standard.set(hearts, forKey: "hearts")
        UserDefaults.standard.set(Date(), forKey: "lastActiveDate")
    }

    func updateHearts() {
        if workoutGameCompleted {
            hearts = min(hearts + 1, 5)
            workoutGameCompleted = false
        }
    }
}

// Preview for the DollStatusView
struct DollStatusView_Previews: PreviewProvider {
    static var previews: some View {
        DollStatusView(username: .constant("thebaby"), equippedBaby: .constant("NiceBaby_Monkey"))
    }
}
