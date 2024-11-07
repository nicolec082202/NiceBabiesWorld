
import SwiftUI

struct CarouselItemModel: Identifiable {
    let id: Int
    let name: String
    let image: Image
}

extension Color {
    // RGB Values
    static let dropshot = Color(red: 0.976470588, green: 0.5333333, blue: 0.0196078431)
    static let doublebounce = Color(red: 0.952941176, green: 0.337254902, blue: 0.584313725)
}

struct ClosetView: View {
    @StateObject var UIState = UIStateModel()
    @Binding var equippedBaby: String
    @Environment(\.presentationMode) var isClosetViewPresented

    
    var body: some View {
        let spacing: CGFloat = 130
        let cardHeight: CGFloat = 180
        
        let items = [
            CarouselItemModel(id: 0, name: "Fish", image: Image("NiceBaby_Fish")),
            CarouselItemModel(id: 1, name: "Monkey", image: Image("NiceBaby_Monkey")),
            CarouselItemModel(id: 2, name: "Sheep", image: Image("NiceBaby_Sheep")),
            CarouselItemModel(id: 3, name: "Panda", image: Image("NiceBaby_Panda")),
            CarouselItemModel(id: 4, name: "Cow", image: Image("NiceBaby_Cow")),
            CarouselItemModel(id: 5, name: "Rabbit", image: Image("NiceBaby_Rabbit")),
            
        ]
        
        ZStack {
            Canvas{
                Carousel(
                    numberOfItems: CGFloat(items.count),
                    spacing: spacing
                ) {
                    ForEach(items) { item in
                        Item(
                            _id: Int(item.id),
                            spacing: spacing,
                            cardHeight: cardHeight
                        ) {
                            VStack {
                                item.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity, minHeight: 540)
                            }
                            .cornerRadius(8)
                            .transition(AnyTransition.slide)
                            .animation(.spring())
                        }
                    }
                }
                //This dynamically updates the baby that is currently in view (activecard)
                .environmentObject(UIState)
            }
            // Page control indicator
            HStack(spacing: 8) {
                ForEach(0..<items.count, id: \.self) { index in
                    Circle()
                        .fill(UIState.activeCard == index ? Color.doublebounce : Color.dropshot)
                        .frame(width: 10, height: 10)
                        .animation(.easeInOut, value: UIState.activeCard)
                }
            }
            .padding(.top, 485)
            VStack {
                Button(action: {
                    let selectedBaby = items[UIState.activeCard].name
                    print("\(selectedBaby)") //debugging purposes
                    equippedBaby = "NiceBaby_\(selectedBaby)"
                    //print("\(equippedBaby)") //debugging purposes
                    isClosetViewPresented.wrappedValue.dismiss()
                    
                }) {
                    Text("EQUIP")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.white)
                        .frame(width: 120, height: 50)
                        .background(Color.dropshot)
                        .cornerRadius(25)
                }
                .padding(.top, 590)
                
            }
            
        }
    }
    
    public class UIStateModel: ObservableObject {
        @Published var activeCard: Int = 0
        @Published var screenDrag: Float = 145
    }
    
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
            @ViewBuilder _ items: () -> Items) {
                
                // Setting up carousel parameters
                self.items = items()
                self.numberOfItems = numberOfItems
                self.spacing = spacing
                self.totalSpacing = (numberOfItems - 1) * spacing
                self.cardWidth = (UIScreen.main.bounds.width - (spacing * 3)) / 2
                
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
        }
    }
    struct Canvas<Content : View> : View {
        let content: Content
        @EnvironmentObject var UIState: UIStateModel
        
        @inlinable init(@ViewBuilder _ content: () -> Content) {
            self.content = content()
            
        }
        
        //Background image
        var body: some View {
            content
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .background(Image("closetBackground")
                    .resizable()
                    .ignoresSafeArea()
                    .blur(radius: 5, opaque: true))
        }
    }
    
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
        }
        
        var body: some View {
            content
                .frame(width: cardWidth, height: _id == UIState.activeCard ? cardHeight : cardHeight - 1, alignment: .center)
                .scaleEffect(_id == UIState.activeCard ? 1.5 : 0.7)  // Scale effect for active card
                .padding(.top, _id == UIState.activeCard ? 140 : 0)
                .animation(.spring())
        }
    }
    
    // Preview of the ClosetView for development in Xcode
    struct ClosetView_Previews: PreviewProvider {
        static var previews: some View {
            ClosetView(equippedBaby: .constant("Monkey"))
                .environmentObject(UIStateModel())
        }
    }
}

