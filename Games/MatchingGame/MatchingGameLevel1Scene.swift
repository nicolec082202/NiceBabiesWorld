import SpriteKit
import SwiftUI

class MatchingGameLevel1Scene: SKScene {
    // MARK: - Properties
    private var cards: [Card] = []
    private var flippedCards: [Card] = []
    private var isProcessingMatch = false
    private var points = 0
    private var timeRemaining: TimeInterval = 120 // 2 minutes
    private var timer: Timer?
    private var timerLabel: SKLabelNode?
    private var pointsLabel: SKLabelNode?
    var equippedBaby: String = ""
    
    // MARK: - Layout Constants
    private let columns = 3
    private let rows = 4
    private let cardSpacing: CGFloat = 20
    
    // MARK: - Lifecycle
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "Card Game Background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2) // Center the background
        background.zPosition = -1 // Ensure it appears behind all other nodes
        background.size = self.size // Make the background cover the entire scene
        addChild(background)
        setupGame()
    }
    
    private func setupGame() {
        backgroundColor = .systemBlue.withAlphaComponent(0.3)
        setupUI()
        createCards()
        startTimer()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        setupHeader()
        setupBottomBar()
    }
    
    private func setupHeader() {
        // Timer
        let timerBackground = SKShapeNode(rectOf: CGSize(width: 200, height: 60))
        timerBackground.fillColor = .brown.withAlphaComponent(0.3)
        timerBackground.strokeColor = .clear
        timerBackground.position = CGPoint(x: size.width / 2, y: size.height)
        addChild(timerBackground)
        
        timerLabel = SKLabelNode(text: "2:00")
        timerLabel?.fontSize = 32
        timerLabel?.fontColor = .black
        timerLabel?.position = CGPoint(x: size.width / 2, y: size.height - 50)
        if let timerLabel = timerLabel {
            addChild(timerLabel)
        }
        
        // Points
        pointsLabel = SKLabelNode(text: "Points: 0")
        pointsLabel?.fontSize = 24
        pointsLabel?.fontColor = .black
        pointsLabel?.position = CGPoint(x: size.width - 100, y: size.height - 40)
        if let pointsLabel = pointsLabel {
            addChild(pointsLabel)
        }
    }
    
    private func setupBottomBar() {
        let bottomBar = SKShapeNode(rectOf: CGSize(width: size.width, height: 80))
        bottomBar.strokeColor = .clear
        bottomBar.position = CGPoint(x: size.width / 2, y: 40)
        addChild(bottomBar)

        
        // End Button
        let endButton = SKSpriteNode(imageNamed: "Exit_Button")
        endButton.name = "exit"
        endButton.position = CGPoint(x: size.width/2, y: 40)
        endButton.setScale(0.5)
        addChild(endButton)
    }
    
    // MARK: - Card Management
    
    private func createCards() {

        // Spacing between cards
        let cardSpacing: CGFloat = 20

        // Define the vertical area where cards should be placed
        let topMargin: CGFloat = 100 // Distance below the points indicator
        let bottomMargin: CGFloat = 100 // Distance above the exit button

        // Calculate card dimensions based on the available area
        let availableHeight = size.height - topMargin - bottomMargin - (cardSpacing * CGFloat(rows + 1))
        let cardHeight = availableHeight / CGFloat(rows)
        let cardWidth = cardHeight * 0.7// Adjust width-to-height ratio as needed

        // Generate the baby pairs
        let babyTypes = generateBabyPairs()
        var cardIndex = 0

        // Loop to create cards
        for row in 0..<rows {
            for column in 0..<columns {
                // Calculate card positions
                let x = cardSpacing + (cardWidth + cardSpacing) * CGFloat(column) + cardWidth / 2
                let y = size.height - topMargin - (cardSpacing + (cardHeight + cardSpacing) * CGFloat(row)) - cardHeight / 2

                // Create and position the card
                let card = Card(size: CGSize(width: cardWidth, height: cardHeight),
                                position: CGPoint(x: x, y: y),
                                babyType: babyTypes[cardIndex])
                cards.append(card)
                addChild(card)

                // Increment card index
                cardIndex += 1
            }
        }
    }

    
    private func generateBabyPairs() -> [String] {
        let babyAssets = ["NiceBaby_Cow", "NiceBaby_Fish", "NiceBaby_Monkey", "NiceBaby_Panda", "NiceBaby_Rabbit", "NiceBaby_Sheep"]
        var pairs = babyAssets + babyAssets
        pairs.shuffle()
        return pairs
    }
    
    // MARK: - Game Logic
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.timeRemaining -= 1
            self.updateTimerDisplay()
            
            if self.timeRemaining <= 0 {
                self.endGame(success: false)
            }
        }
    }
    
    private func updateTimerDisplay() {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        timerLabel?.text = String(format: "%d:%02d", minutes, seconds)
    }
    
    private func handleCardTap(_ card: Card) {
        guard !card.isFlipped,
              flippedCards.count < 2,
              !isProcessingMatch else { return }
        
        card.flip()
        flippedCards.append(card)
        
        if flippedCards.count == 2 {
            checkForMatch()
        }
    }
    
    private func checkForMatch() {
        isProcessingMatch = true
        
        let card1 = flippedCards[0]
        let card2 = flippedCards[1]
        
        if card1.babyType == card2.babyType {
            points += 10
            pointsLabel?.text = "Points: \(points)"
            flippedCards.removeAll()
            isProcessingMatch = false
            
            if isGameComplete() || points >= 60{
                endGame(success: true)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                card1.flip()
                card2.flip()
                self?.flippedCards.removeAll()
                self?.isProcessingMatch = false
            }
        }
    }
    
    private func isGameComplete() -> Bool {
        return cards.allSatisfy { $0.isFlipped }
    }
    
    private func endGame(success: Bool) {
        timer?.invalidate()
        timer = nil
        
        showGameOverPopup(success: success)
        
        if success {
            updateBabyHearts()
        }
    }
    
    private func updateBabyHearts() {
       //baby hearts
    }
    
    // MARK: - Navigation
    private func navigateToMainMenu() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let mainMenuScene = MatchingGameMainMenuScene(size: size)
        view?.presentScene(mainMenuScene, transition: transition)
    }
    
//    private func navigateToNextLevel() {
//        let transition = SKTransition.fade(withDuration: 0.5)
//        let nextLevelScene = MatchingGameLevel2Scene(size: size)
//        view?.presentScene(nextLevelScene, transition: transition)
//    }
    
    private func restartLevel() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let newScene = MatchingGameLevel1Scene(size: size)
        view?.presentScene(newScene, transition: transition)
    }
    
    // MARK: - Popups
  /*  private func showGameOverPopup(success: Bool) {
        
        let popup = SKNode()
        
        
        // Background for the popup
        let popupBackground = SKSpriteNode(imageNamed: success ? "LevelCompleted" : "LevelFailed")
        popupBackground.size = CGSize(width: 280, height: 300) // Adjust size as needed
        popupBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        popup.addChild(popupBackground)
        
       /* let titleLabel = SKLabelNode(text: success ? "LevelCompleted" : "LevelFailed")
        titleLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 150)
        popup.addChild(titleLabel)*/
        
        let timeLabel = SKLabelNode(text: "\(Int(120 - timeRemaining))s")
            timeLabel.fontSize = 24
            timeLabel.fontColor = .white
            timeLabel.position = CGPoint(x: 40, y: 50) // Adjust position
            popupBackground.addChild(timeLabel)

            // Points Earned
            let pointsLabel = SKLabelNode(text: "\(points)")
            pointsLabel.fontSize = 24
            pointsLabel.fontColor = .white
            pointsLabel.position = CGPoint(x: 40, y: 30) // Adjust position
            popupBackground.addChild(pointsLabel)

            // Add Replay and Exit buttons
            addPopupButton(to: popupBackground, imageName: "Replay_Icon", actionName: "replay", position: CGPoint(x: -100, y: -100))
            addPopupButton(to: popupBackground, imageName: "Exit_Button", actionName: "exit", position: CGPoint(x: 100, y: -100))

            // Add the popup to the scene
            addChild(popup)
    }*/
    
    private func showGameOverPopup(success: Bool) {
        let popup = SKNode()

        // Background for the popup
        let popupBackground = SKSpriteNode(imageNamed: success ? "LevelCompleted" : "LevelFailed")
        popupBackground.size = CGSize(width: 280, height: 300) // Adjust size as needed
        popupBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        popup.addChild(popupBackground)

        // Time Remaining
        let timeLabel = SKLabelNode(text: "\(Int(120 - timeRemaining))s")
        timeLabel.fontSize = 24
        timeLabel.fontColor = .white
        timeLabel.position = CGPoint(x: 40, y: 30) // Shifted down slightly (adjust Y value as needed)
        popupBackground.addChild(timeLabel)

        // Points Earned
        let pointsLabel = SKLabelNode(text: "\(points)")
        pointsLabel.fontSize = 24
        pointsLabel.fontColor = .white
        pointsLabel.position = CGPoint(x: 40, y: 10) // Shifted down slightly (adjust Y value as needed)
        popupBackground.addChild(pointsLabel)

        // Replay and Exit Buttons
        addPopupButton(
            to: popupBackground,
            imageName: "Replay_Icon",
            actionName: "replay",
            position: CGPoint(x: -100, y: -115) // Shifted down slightly (adjust Y value as needed)
        )
        addPopupButton(
            to: popupBackground,
            imageName: "Exit_Button",
            actionName: "exit",
            position: CGPoint(x: 100, y: -115) // Shifted down slightly (adjust Y value as needed)
        )

        // Add the popup to the scene
        addChild(popup)
    }

    
    /*private func addPopupButton(to parent: SKNode, title: String, position: CGPoint) {
        let button = SKLabelNode(text: title)
        button.position = position
        button.name = title.lowercased().replacingOccurrences(of: " ", with: "_")
        parent.addChild(button)
    }*/
    
    private func addPopupButton(to parent: SKNode, imageName: String, actionName: String, position: CGPoint) {
        let button = SKSpriteNode(imageNamed: imageName)
        button.name = actionName // Assign the action name for touch detection
        button.position = position
        button.setScale(0.45) // Adjust scale as needed
        parent.addChild(button)
    }

    
    // MARK: - Touch Handling
    
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        let touchedNodes = nodes(at: location)
        print("Touched nodes: \(touchedNodes)")

        for node in touchedNodes {
            // Traverse up to find the parent Card node
            if let card = node as? Card ?? node.parent as? Card {
                print("Card tapped: \(card.babyType)")
                handleCardTap(card)
                return
            }
        }

        // Handle other touchable nodes (e.g., buttons)
        if let touchedNode = touchedNodes.first {
            if touchedNode.name == "Exit_Button" {
                navigateToMainMenu()
            } else if touchedNode.name == "Replay_Icon" {
                restartLevel()
            }
        }
    }*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        let touchedNodes = nodes(at: location)
        for node in touchedNodes {
            if let card = node as? Card ?? node.parent as? Card {
                handleCardTap(card)
                return
            }

            if let buttonName = node.name {
                switch buttonName {
                case "replay":
                    restartLevel()
                case "exit":
                    navigateToMainMenu()
                default:
                    break
                }
            }
        }
    }



    
    
    
}

// MARK: - Card Class


class Card: SKNode {
    private var frontSprite: SKSpriteNode // The front of the card (Card_Backside)
    private var backCardSprite: SKSpriteNode // The back card design (Card_Frontside)
    private var babySprite: SKSpriteNode // The baby image displayed on the back
    private(set) var isFlipped = false
    private var isFlipping = false // Prevent simultaneous flips
    private(set) var babyType: String

    init(size: CGSize, position: CGPoint, babyType: String) {
        self.babyType = babyType

        // Initialize sprites
        self.frontSprite = SKSpriteNode(imageNamed: "Card_Backside")
        self.backCardSprite = SKSpriteNode(imageNamed: "Card_Frontside")
        self.babySprite = SKSpriteNode(imageNamed: babyType)

        super.init()

        self.name = "Card-\(babyType)" // Assign a unique name to the card
        self.position = position

        setupSprites(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSprites(size: CGSize) {
        // Set sprite sizes
        frontSprite.size = size
        backCardSprite.size = size
        babySprite.size = CGSize(width: size.width * 0.7, height: size.height * 0.7) // Baby is slightly smaller than the card

        // Position babySprite on top of backCardSprite
        babySprite.position = .zero // Centered on the back card

        // Add sprites to the card node
        addChild(frontSprite)
        addChild(backCardSprite)
        backCardSprite.addChild(babySprite)

        // Initially show only the front side
        backCardSprite.isHidden = true
    }

    func flip() {
        guard !isFlipping else { return } // Prevent multiple simultaneous flips
        isFlipping = true

        print("Flipping card: \(babyType)")

        // Scale to 0.0 (shrink) on the X-axis for the first half
        let shrink = SKAction.scaleX(to: 0.0, duration: 0.2)

        // Swap textures midway through the flip
        let swapTextures = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.frontSprite.isHidden.toggle()
            self.backCardSprite.isHidden.toggle()
        }

        // Scale back to the original size (expand) on the X-axis for the second half
        let expand = SKAction.scaleX(to: 1.0, duration: 0.2)

        // Sequence for flipping animation
        let flipSequence = SKAction.sequence([shrink, swapTextures, expand])

        // Run the flip animation and reset flipping state
        run(flipSequence) { [weak self] in
            self?.isFlipped.toggle()
            self?.isFlipping = false
        }
    }
}


