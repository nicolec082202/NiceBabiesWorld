import SwiftUI

struct GameView: View {
    var gameType: GameType  // The type of game to display
    @Binding var isGamePresented: Bool  // Control game dismissal

    var body: some View {
        SpriteKitView(gameType: gameType)
            .overlay(
                Button(action: {
                    isGamePresented = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 40))
                        .padding()
                        .foregroundColor(.white)
                }
                .position(x: UIScreen.main.bounds.width - 50, y: 50),
                alignment: .topTrailing
            )
    }
}
