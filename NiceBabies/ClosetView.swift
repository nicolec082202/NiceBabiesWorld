import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CarouselItemModel: Identifiable {
    let id: Int
    let name: String
    let image: Image
}

extension Color {
    static let dropshot = Color(red: 0.976470588, green: 0.5333333, blue: 0.0196078431)
    static let doublebounce = Color(red: 0.952941176, green: 0.337254902, blue: 0.584313725)
}

struct ClosetView: View {
    @StateObject private var uiState = UIStateModel()
  //  @State private var equippedBaby = ""
    @Environment(\.presentationMode) var isClosetViewPresented
    @Binding var equippedBaby: String // Add binding for equippedBaby
    
    let items = [
        CarouselItemModel(id: 0, name: "Fish", image: Image("NiceBaby_Fish")),
        CarouselItemModel(id: 1, name: "Monkey", image: Image("NiceBaby_Monkey")),
        CarouselItemModel(id: 2, name: "Panda", image: Image("NiceBaby_Panda")),
        CarouselItemModel(id: 3, name: "Rabbit", image: Image("NiceBaby_Rabbit"))
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Image("HomePage Background")
                    .resizable()
                    //.scaledToFill()
                    .frame(width: geometry.size.width*1.59, height: geometry.size.height*1.12)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.555)
                    .blur(radius: 5)
                    .edgesIgnoringSafeArea(.all)
                

                
                VStack {
                    // Close Button
                    HStack {
                        Button(action: {
                            isClosetViewPresented.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 24, weight: .bold))
                                .padding()
                                .background(Circle().fill(Color.white))
                                .foregroundColor(.black)
                                .shadow(radius: 2)
                        }
                        .padding()
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // Carousel
                    VStack {
                        GeometryReader { carouselGeometry in
                            HStack(spacing: 0) {
                                ForEach(items) { item in
                                    ItemView(item: item, geometry: carouselGeometry, activeCard: uiState.activeCard)
                                }
                            }
                            .offset(x: -CGFloat(uiState.activeCard) * carouselGeometry.size.width)
                            .animation(.spring(), value: uiState.activeCard)
                            .gesture(
                                DragGesture()
                                    .onEnded { value in
                                        let translation = value.translation.width
                                        let threshold = carouselGeometry.size.width * 0.3
                                        
                                        if translation < -threshold && uiState.activeCard < items.count - 1 {
                                            uiState.activeCard += 1
                                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                            impactMed.impactOccurred()
                                        } else if translation > threshold && uiState.activeCard > 0 {
                                            uiState.activeCard -= 1
                                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                            impactMed.impactOccurred()
                                        }
                                    }
                            )
                        }
                        .aspectRatio(1, contentMode: .fit)
                        .padding(.horizontal)
                        
                        // Page Control
                        HStack(spacing: 10) {
                            ForEach(0..<items.count, id: \.self) { index in
                                Circle()
                                    .fill(uiState.activeCard == index ? Color.doublebounce : Color.dropshot)
                                    .frame(width: 10, height: 10)
                            }
                        }
                        .padding(.top)
                        
                        // Equip Button
                        Button(action: {
                            let selectedBaby = items[uiState.activeCard].name
                            equippedBaby = "NiceBaby_\(selectedBaby)"
                            updateEquippedBaby(inFirestore: equippedBaby)
                            isClosetViewPresented.wrappedValue.dismiss()
                        }) {
                            Text("EQUIP")
                                .font(.system(size: 25, weight: .regular))
                                .foregroundColor(.white)
                                .frame(width: 130, height: 50)
                                .background(Color.dropshot)
                                .cornerRadius(25)
                        }
                        .padding(.top)
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    // Update Firebase function remains the same
    func updateEquippedBaby(inFirestore newEquippedBaby: String) {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user")
            return
        }

        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(user.uid)

        userDocRef.updateData(["equippedBaby": newEquippedBaby]) { error in
            if let error = error {
                print("Error updating equippedBaby: \(error.localizedDescription)")
            } else {
                print("Successfully updated equippedBaby to \(newEquippedBaby)")
            }
        }
    }
}

// Custom Item View to handle scaling and positioning
struct ItemView: View {
    let item: CarouselItemModel
    let geometry: GeometryProxy
    let activeCard: Int
    
    var body: some View {
        VStack {
            item.image
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .cornerRadius(15)
                .shadow(radius: 10)
        }
        .frame(width: geometry.size.width)
        .scaleEffect(activeCard == item.id ? 1.0 : 0.8)
        .opacity(activeCard == item.id ? 1.0 : 0.7)
        .animation(.spring(), value: activeCard)
    }
}

// UIStateModel remains the same
public class UIStateModel: ObservableObject {
    @Published var activeCard: Int = 0
    @Published var screenDrag: Float = 0
}

// Preview provider
struct ClosetView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView(equippedBaby: .constant("NiceBaby_Monkey"))
            .environmentObject(UIStateModel())
    }
}
