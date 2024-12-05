import SwiftUI

class UIStateModel: ObservableObject {
    @Published var activeCard: Int = 0
    @Published var screenDrag: Float = 0.0
}

extension Color {
    static let dropshot = Color(red: 0.976, green: 0.533, blue: 0.020)
    static let doublebounce = Color(red: 0.953, green: 0.337, blue: 0.584)
}

struct ClosetView: View {
    
    @State private var currentPage = 0 // Track the current page
    @StateObject var UIState = UIStateModel()
    @Binding var equippedBaby: String
    @Environment(\.presentationMode) var isClosetViewPresented
    
    let items = [
        "NiceBaby_Fish",
        "NiceBaby_Monkey",
        "NiceBaby_Sheep",
        "NiceBaby_Panda",
        "NiceBaby_Cow",
        "NiceBaby_Rabbit"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                // Blurry Background
                Image("HomePage Background")
                    .resizable()
                    .ignoresSafeArea()
                    .frame(width: width * 1.59, height: height)
                    .position(x: width * 0.5, y: height * 0.5)
                    .blur(radius: 5, opaque: true)
                
                if #available(iOS 17.0, *) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
                            ForEach(items.indices, id: \.self) { index in
                                Image(items[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: width * 0.7, height: height * 0.7)
                                    .padding(.horizontal, 20)
                                    .containerRelativeFrame(.horizontal)
                                    .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1.0 : 0.8)
                                            .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                                    }
                                    .onTapGesture {
                                        UIState.activeCard = index
                                        print("Tapped on card: \(index)")
                                    }
                                    .onAppear {
                                        withAnimation {
                                            currentPage = index
                                        }
                                    }
                            }
                        }
                    }
                    .scrollTargetBehavior(.paging)
                    .onChange(of: UIState.activeCard) { newValue in
                        currentPage = newValue
                        print("Active card changed to: \(newValue)")
                    }
                    .onAppear {
                        // Reset the currentPage when the view appears
                        UIState.activeCard = 0
                    }
                    
                    // Page Indicator
                    HStack {
                        ForEach(items.indices, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.dropshot : Color.doublebounce)
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding(.top, height * 0.35)
                    
                } else {
                    // Fallback for earlier iOS versions
                   
                }
                
                // Equip Button
                VStack {
                    Button(action: {
                        guard UIState.activeCard >= 0 && UIState.activeCard < items.count else { return }
                        equippedBaby = items[UIState.activeCard]
                        print("Equipped baby: \(equippedBaby)")
                        isClosetViewPresented.wrappedValue.dismiss()
                    }) {
                        Text("EQUIP")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.white)
                            .frame(width: width * 0.5, height: height * 0.07)
                            .background(Color.dropshot)
                            .cornerRadius(height * 0.035)
                    }
                    .padding(.top, height * 0.85)
                }
                
                // Close button
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
                .padding(.bottom, height * 0.9)
            }
        }
    }
}

struct CloseView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView(equippedBaby: .constant("Monkey"))
            .environmentObject(UIStateModel())
    }
}
