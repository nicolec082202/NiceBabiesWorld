
import SwiftUI

struct CarouselItemModel: Identifiable {
    let id: Int
    let name: String
    let image: Image
}//end CarouselItemModel

extension Color {
    // RGB Values
    static let dropshot = Color(red: 0.976470588, green: 0.5333333, blue: 0.0196078431)
    static let doublebounce = Color(red: 0.952941176, green: 0.337254902, blue: 0.584313725)
} //end Color

struct ClosetView: View {
    @StateObject var UIState = UIStateModel()
    @Binding var equippedBaby: String
    @Environment(\.presentationMode) var isClosetViewPresented

    
    var body: some View {
        let items = [
            CarouselItemModel(id: 0, name: "Fish", image: Image("NiceBaby_Fish")),
            CarouselItemModel(id: 1, name: "Monkey", image: Image("NiceBaby_Monkey")),
            CarouselItemModel(id: 2, name: "Sheep", image: Image("NiceBaby_Sheep")),
            CarouselItemModel(id: 3, name: "Panda", image: Image("NiceBaby_Panda")),
            CarouselItemModel(id: 4, name: "Cow", image: Image("NiceBaby_Cow")),
            CarouselItemModel(id: 5, name: "Rabbit", image: Image("NiceBaby_Rabbit")),
            
        ]
        
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let cardSpacing = screenWidth * 0.08
            let cardWidth = screenWidth * 0.7
            let cardHeight = screenHeight * 0.5
            
            ZStack {
                Canvas {
                    Carousel(
                        numberOfItems: CGFloat(items.count),
                        spacing: cardSpacing,
                        cardWidth: cardWidth
                    ) {
                        ForEach(items) { item in
                            Item(
                                _id: Int(item.id),
                                spacing: cardSpacing,
                                cardHeight: cardHeight
                            ) {
                                VStack {
                                    item.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: cardWidth, height: cardHeight)
                                    
                                }
                                .cornerRadius(8)
                                .transition(.slide)
                                .animation(.spring())
                            }
                        }
                    }
                    .environmentObject(UIState)
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
                .padding(.bottom, screenHeight * 0.9)
                
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<items.count, id: \.self) { index in
                        Circle()
                            .fill(UIState.activeCard == index ? Color.doublebounce : Color.dropshot)
                            .frame(width: 10, height: 10)
                            .animation(.easeInOut, value: UIState.activeCard)
                    }
                }
                .padding(.top, screenHeight * 0.75)
                
                // Equip button
                VStack {
                    Button(action: {
                        let selectedBaby = items[UIState.activeCard].name
                        equippedBaby = "NiceBaby_\(selectedBaby)"
                        isClosetViewPresented.wrappedValue.dismiss()
                    }) {
                        Text("EQUIP")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.white)
                            .frame(width: screenWidth * 0.5, height: screenHeight * 0.07)
                            .background(Color.dropshot)
                            .cornerRadius(screenHeight * 0.035)
                    }
                    .padding(.top, screenHeight * 0.85)
                }
            }
        }
    }
    
    public class UIStateModel: ObservableObject {
        @Published var activeCard: Int = 0
        @Published var screenDrag: Float = 145
    }//end UIStateModel
    
    struct Carousel<Items : View> : View {
        // Initializing necessary properties for the carousel
        // Including a timer for automatic sliding
        let items: Items
        let numberOfItems: CGFloat
        let spacing: CGFloat
        let totalSpacing: CGFloat
        let cardWidth: CGFloat
        
        // Gesture state for drag detection
        @GestureState var isDetectingLongPress = false
        
        // Accessing UI state
        @EnvironmentObject var UIState: UIStateModel
        
        @inlinable public init(
            numberOfItems: CGFloat,
            spacing: CGFloat,
            cardWidth: CGFloat,
            @ViewBuilder _ items: () -> Items) {
                
                // Setting up carousel parameters
                self.items = items()
                self.numberOfItems = numberOfItems
                self.spacing = spacing
                self.cardWidth = cardWidth
                self.totalSpacing = (numberOfItems - 1) * spacing
                
                
            }
        
        // Body of the carousel view
        var body: some View {
            let screenWidth = UIScreen.main.bounds.width
            
            // Calculate the position that centers the active card
            let centralizeOffset = (screenWidth - cardWidth) / 2.0
            
            // Calculate the offset for the current active card
            let activeOffset = CGFloat(UIState.activeCard) * -(cardWidth + spacing)
            
            // Combine offsets with drag
            let totalOffset = centralizeOffset + activeOffset + CGFloat(UIState.screenDrag)
            
            return HStack(alignment: .top, spacing: spacing) {
                items
            }
            .offset(x: totalOffset, y: 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: UIState.activeCard)
            .gesture(
                DragGesture()
                    .updating($isDetectingLongPress) { currentState, gestureState, transaction in
                        UIState.screenDrag = Float(currentState.translation.width) + 145
                    }
                    .onEnded { value in
                        UIState.screenDrag = 145
                        // Move right
                        if (value.translation.width < -50) && UIState.activeCard < Int(numberOfItems) - 1 {
                            withAnimation(.spring()) {
                                UIState.activeCard = UIState.activeCard + 1
                            }
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                        }
                        // Move left
                        if (value.translation.width > 50) && UIState.activeCard > 0 {
                            withAnimation(.spring()) {
                                UIState.activeCard = UIState.activeCard - 1
                            }
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                        }
                    }
            )
        }// end body
        
    }//end Carousel
    
    
    
    struct Canvas<Content : View> : View {
        let content: Content
        @EnvironmentObject var UIState: UIStateModel
        
        @inlinable init(@ViewBuilder _ content: () -> Content) {
            self.content = content()
            
        }
        
        //Background image
        var body: some View {
            
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                content
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    .background(Image("HomePage Background")
                        .resizable()
                        .ignoresSafeArea()
                        .frame(width: width*1.59, height: height)
                        .position(x: width * 0.5, y: height * 0.5)
                        .blur(radius: 5, opaque: true))
            }
        }//end body
        
    }//end canvas
    
    struct Item<Content: View>: View {
        
        @EnvironmentObject var UIState: UIStateModel
        let cardWidth: CGFloat
        let cardHeight: CGFloat
        var _id: Int
        var content: Content
        
        @inlinable public init(
            _id: Int,
            spacing: CGFloat,
            //widthOfHiddenCards: CGFloat,
            cardHeight: CGFloat,
            @ViewBuilder _ content: () -> Content
        ) {
            self.content = content()
            self.cardWidth = (UIScreen.main.bounds.width - (spacing * 3)) / 2
            self.cardHeight = cardHeight
            self._id = _id
        }// end inlinable
        
        var body: some View {
            content
                .frame(width: cardWidth, height: _id == UIState.activeCard ? cardHeight : cardHeight - 1, alignment: .center)
                .scaleEffect(_id == UIState.activeCard ? 1.5 : 0.7)  // Scale effect for active card
                .padding(.top, _id == UIState.activeCard ? 140 : 0)
                .animation(.spring())
        }// end body
        
    }//endItem
    
    
    
    // Preview of the ClosetView for development in Xcode
    struct ClosetView_Previews: PreviewProvider {
        static var previews: some View {
            ClosetView(equippedBaby: .constant("Monkey"))
                .environmentObject(UIStateModel())
        }
    }//end ClosetView_Previews

    
}//end ClosetView

