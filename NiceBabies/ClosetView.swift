import SwiftUI

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
            CarouselItemModel(id: 5, name: "Rabbit", image: Image("NiceBaby_Rabbit"))
        ]

        ZStack {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height
                let spacing: CGFloat = screenWidth * 0.1
                let cardHeight: CGFloat = screenHeight * 0.3

                Canvas {
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
                                        .frame(maxWidth: .infinity, minHeight: screenHeight * 0.6)
                                }
                                .cornerRadius(8)
                                .transition(AnyTransition.slide)
                                .animation(.spring())
                            }
                        }
                    }
                    .environmentObject(UIState)
                }

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
                .padding(.bottom, screenHeight * 0.8)

                HStack(spacing: 8) {
                    ForEach(0..<items.count, id: \.self) { index in
                        Circle()
                            .fill(UIState.activeCard == index ? Color.doublebounce : Color.dropshot)
                            .frame(width: 10, height: 10)
                            .animation(.easeInOut, value: UIState.activeCard)
                    }
                }
                .padding(.top, screenHeight * 0.85)

                VStack {
                    Spacer()
                    Button(action: {
                        let selectedBaby = items[UIState.activeCard].name
                        equippedBaby = "NiceBaby_\(selectedBaby)"
                        isClosetViewPresented.wrappedValue.dismiss()
                    }) {
                        Text("EQUIP")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.white)
                            .frame(width: 120, height: 50)
                            .background(Color.dropshot)
                            .cornerRadius(25)
                    }
                    .padding(.bottom, screenHeight * 0.05)
                }
                .frame(width: screenWidth, height: screenHeight, alignment: .bottom)
            }
        }
    }
}

public class UIStateModel: ObservableObject {
    @Published var activeCard: Int = 0
    @Published var screenDrag: Float = 145
}

struct Carousel<Items: View>: View {
    let items: Items
    let numberOfItems: CGFloat
    let spacing: CGFloat
    let totalSpacing: CGFloat
    let cardWidth: CGFloat

    @GestureState var isDetectingLongPress = false
    @EnvironmentObject var UIState: UIStateModel

    @inlinable public init(
        numberOfItems: CGFloat,
        spacing: CGFloat,
        @ViewBuilder _ items: () -> Items
    ) {
        self.items = items()
        self.numberOfItems = numberOfItems
        self.spacing = spacing
        self.totalSpacing = (numberOfItems - 1) * spacing
        self.cardWidth = (UIScreen.main.bounds.width - (spacing * 3)) / 2
    }

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let centralizeOffset = (screenWidth - cardWidth) / 2.0
            let activeOffset = CGFloat(UIState.activeCard) * -(cardWidth + spacing)
            let totalOffset = centralizeOffset + activeOffset + CGFloat(UIState.screenDrag)

            HStack(alignment: .center, spacing: spacing) {
                items
            }
            .frame(height: screenHeight * 0.6) // Center vertically
            .offset(x: totalOffset, y: 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: UIState.activeCard)
            .gesture(
                DragGesture()
                    .updating($isDetectingLongPress) { currentState, gestureState, transaction in
                        UIState.screenDrag = Float(currentState.translation.width) + 145
                    }
                    .onEnded { value in
                        UIState.screenDrag = 145
                        if (value.translation.width < -50) && UIState.activeCard < Int(numberOfItems) - 1 {
                            withAnimation(.spring()) {
                                UIState.activeCard += 1
                            }
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                        }
                        if (value.translation.width > 50) && UIState.activeCard > 0 {
                            withAnimation(.spring()) {
                                UIState.activeCard -= 1
                            }
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                        }
                    }
            )
        }
    }
}

struct Canvas<Content: View>: View {
    let content: Content
    @EnvironmentObject var UIState: UIStateModel

    @inlinable init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            content
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .background(
                    Image("HomePage Background")
                        .resizable()
                        .ignoresSafeArea()
                        .frame(width: width * 1.59, height: height)
                        .position(x: width * 0.5, y: height * 0.5)
                        .blur(radius: 5, opaque: true)
                )
        }
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
            .scaleEffect(_id == UIState.activeCard ? 1.5 : 0.7)
            .padding(.top, _id == UIState.activeCard ? 140 : 0)
            .animation(.spring())
    }
}

struct ClosetView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView(equippedBaby: .constant("Monkey"))
            .environmentObject(UIStateModel())
    }
}
