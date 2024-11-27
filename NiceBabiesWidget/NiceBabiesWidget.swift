import WidgetKit
import SwiftUI
import os

private let logger = Logger(subsystem: "com.nicebabies", category: "NiceBabyWidget")

struct NiceBabyEntry: TimelineEntry {
    let date: Date
    let hearts: Double
    let equippedBaby: String
}


extension Color {
    static let backgroundColor = Color(red: 0.78823529412, green: 0.81960784314, blue: 0.80784313725)
    static let darkGray = Color(red: 0.156862745, green: 0.152941176, blue: 0.152941176)
    static let lightGray = Color(red: 0.435294118, green: 0.431372549, blue: 0.431372549)
}

struct NiceBabyProvider: TimelineProvider {
    let defaults = UserDefaults(suiteName: "group.nicebabies") ?? UserDefaults.standard
    func placeholder(in context: Context) -> NiceBabyEntry {
        logger.debug("Widget Placeholder called")
        return NiceBabyEntry(date: Date(), hearts: 5.0, equippedBaby: "NiceBaby_Monkey")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (NiceBabyEntry) -> Void) {
        let hearts = defaults.double(forKey: "hearts")
        let equippedBaby = defaults.string(forKey: "equippedBaby") ?? "NiceBaby_Monkey"
        
        logger.debug("Widget Snapshot - Reading from shared UserDefaults")
        logger.debug("Widget Snapshot - Hearts: \(hearts)")
        logger.debug("Widget Snapshot - EquippedBaby: \(equippedBaby)")
        
        let entry = NiceBabyEntry(date: Date(), hearts: hearts, equippedBaby: equippedBaby)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<NiceBabyEntry>) -> Void) {
        // read from shared defaults
        let hearts = defaults.double(forKey: "hearts")
        let equippedBaby = defaults.string(forKey: "equippedBaby") ?? "NiceBaby_Monkey"
        
        logger.debug("Widget Timeline - Reading from shared UserDefaults")
        logger.debug("Widget Timeline - Hearts: \(hearts)")
        logger.debug("Widget Timeline - EquippedBaby: \(equippedBaby)")
        
        let entry = NiceBabyEntry(date: Date(), hearts: hearts, equippedBaby: equippedBaby)
        let timeline = Timeline(entries: [entry], policy: .atEnd)

        completion(timeline)
    }
}

struct HeartView: View {
    let index: Int
    let heartCount: Double
    let size: CGFloat
    
    var body: some View {
        if Double(index) < heartCount {
            if heartCount - Double(index) > 0.5 {
                Image("full_heart")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size * 1.8, height: size * 2)
                    .saturation(-1)
                    .scaleEffect(size * 0.15)
                
            } else {
                Image("half_heart")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size * 2, height: size * 2)
                    .saturation(-1)
                    .scaleEffect(size * 0.15)
                
            }
        }
    }
}

struct NiceBabyWidgetEntryView: View {
    var entry: NiceBabyEntry
    @Environment(\.widgetFamily) var family
    
    //this is to individually handle the padding based on the png since some appeared off center, it is then passed in to a leading padding modifier
    func getSpriteLeadingPadding(width: CGFloat) -> CGFloat {
        switch spriteName {
        case let name where name.contains("NiceBaby_Panda_Sprite_Neutral"):
            return width * 0.13
        case let name where name.contains("NiceBaby_Monkey_Sprite_Neutral"):
            return width * 0.1
        case let name where name.contains("NiceBaby_Fish_Sprite"):
            return width * 0.06
        case let name where name.contains("NiceBaby_Rabbit_Sprite_Sad"):
            return width * 0.05
        default:
            return 0
        }
    }
    
    func getSpriteTrailingPadding(width: CGFloat) -> CGFloat {
        switch spriteName {
        case let name where name.contains("NiceBaby_Panda_Sprite_Happy"):
            return width * 0.13
        case let name where name.contains("NiceBaby_Rabbit_Sprite_Neutral"):
            return width * 0.05
        case let name where name.contains("NiceBaby_Rabbit_Sprite_Happy"):
            return width * 0.035
        case let name where name.contains("NiceBaby_Monkey_Sprite_Sad"):
            return width * 0.017
        default:
            return 0
        }
    }
    /*
    func getSpriteScaleEffect(width: CGFloat, view for: String) -> CGFloat {
        switch (spriteName, view) {
        case let name where name.contains(<#T##regex: RegexComponent##RegexComponent#>)
        }
    }
    */
    var spriteState: String {
        let state: String
        if entry.hearts >= 3.5 {
            state = "Happy"
        } else if entry.hearts >= 2.0 {
            state = "Neutral"
        } else {
            state = "Sad"
        }
        
        logger.debug("Widget View - Hearts: \(entry.hearts)")
        logger.debug("Widget View - Calculated Sprite State: \(state)")
        return state
    }
    
    var spriteName: String {
        let baseName = entry.equippedBaby.replacingOccurrences(of: "NiceBaby_", with: "")
        logger.debug("Widget View - Sprite Name: NiceBaby_\(baseName)_Sprite_\(spriteState)")
        return "NiceBaby_\(baseName)_Sprite_\(spriteState)"
    }
    
    var body: some View {
        GeometryReader { geometry in
            switch family {
            case .systemSmall:
                smallWidget(in: geometry)
            case .systemMedium:
                mediumWidget(in: geometry)
            case .systemLarge:
                largeWidget(in: geometry)
            default:
                smallWidget(in: geometry)
            }
        }
    }
    
    //SMALL
    func smallWidget(in geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        let heartSize = min(width, height) * 0.09
        
        return ZStack {
            //hearts
            VStack(spacing: height * 0.01) {
                HStack(spacing: width * 0.001) {
                    ForEach(0..<5) { index in
                        HeartView(index: index, heartCount: entry.hearts, size: heartSize)
                    }
                }
                .padding(.top, height * 0.1) // Add top padding to account for border
                Image(spriteName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: height * 0.5)
                    .scaleEffect(spriteName == "NiceBaby_Monkey_Sprite_Sad" ? 0.8 : 1.3) // scale down if sad bc monkey png is too large in comparison to others
                    .padding(.top, height * 0.08)
                    .padding(.leading, getSpriteLeadingPadding(width: width))
                    .padding(.trailing, getSpriteTrailingPadding(width: width))
                
                
                Spacer() // Push content up to account for bottom border area
                    .frame(width: width / 2, height: height / 2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, width * 0.08)
        }
        .containerBackground(Color.backgroundColor, for: .widget)
    }
    
    //MEDIUM
    func mediumWidget(in geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        let heartSize = min(width, height) * 0.09
        
        return ZStack {
            // Background layer
            Color.backgroundColor
            // Main content with adjusted padding
            VStack(spacing: height * 0.1) {
                // Hearts at the top
                HStack(spacing: width * 0.08) {
                    ForEach(0..<5) { index in
                        HeartView(index: index, heartCount: entry.hearts, size: heartSize * 1.2)
                    }
                }
                //.padding(.top, height * 0.1) // Add top padding to account for border
                
                // Sprite image
                Image(spriteName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    //.frame(height: height * 0.7)
                    .scaleEffect(spriteName == "NiceBaby_Monkey_Sprite_Sad" ? 0.65 : 1.3) // scale down if sad bc monkey png is too large in comparison to others
                    //.padding(.top, height * 0.05)
                    .padding(.leading, getSpriteLeadingPadding(width: width))
                    .padding(.trailing, getSpriteTrailingPadding(width: width))
                
                
                //Spacer() // Push content up to account for bottom border area
                    //.frame(width: width / 2, height: height / 2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //.padding(.horizontal, width * 0.1) // Add horizontal padding to keep content away from edges
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundColor)
        .edgesIgnoringSafeArea(.all) // This will extend the background to the edges

    }

    
    //LARGE
    func largeWidget(in geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        let heartSize = min(width, height) * 0.09
        
        return ZStack {
            // Background border design
            // Main content with adjusted padding
            VStack(spacing: height * 0.01) {
                // Hearts at the top
                HStack(spacing: width * 0.08) {
                    ForEach(0..<5) { index in
                        HeartView(index: index, heartCount: entry.hearts, size: heartSize * 0.60)
                    }
                }
                .padding(.top, height * 0.1) // Add top padding to account for border
                
                // Sprite image
                Image(spriteName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: height * 0.7)
                    .scaleEffect(spriteName == "NiceBaby_Monkey_Sprite_Sad" ? 0.65 : 1.0) // scale down if sad bc monkey png is too large in comparison to others
                    .padding(.top, height * 0.05)
                    .padding(.leading, getSpriteLeadingPadding(width: width))
                    .padding(.trailing, getSpriteTrailingPadding(width: width))
                
                
                Spacer() // Push content up to account for bottom border area
                    .frame(width: width / 2, height: height / 2)
            }
            containerBackground(Color.backgroundColor, for: .widget)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, width * 0.08) // Add horizontal padding to keep content away from edges
        }
    }
}
        
        @main
        struct NiceBabyWidget: Widget {
            private let kind = "NiceBabyWidget"
            
            var body: some WidgetConfiguration {
                StaticConfiguration(kind: kind, provider: NiceBabyProvider()) { entry in
                    NiceBabyWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                        Color.clear // This ensures no default white background
                    }
                }
                .configurationDisplayName("NiceBaby Status")
                .description("Shows your NiceBaby's current status and hearts.")
                .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
            }
        }
        
        struct Widget_Previews: PreviewProvider {
            static var previews: some View {
                Group {
                    NiceBabyWidgetEntryView(entry: NiceBabyEntry(
                        date: Date(),
                        hearts: 4.5,
                        equippedBaby: "NiceBaby_Monkey"
                    ))
                    .previewContext(WidgetPreviewContext(family: .systemSmall))
                    .previewDisplayName("Small Widget")
                    
                    NiceBabyWidgetEntryView(entry: NiceBabyEntry(
                        date: Date(),
                        hearts: 1.5,
                        equippedBaby: "NiceBaby_Rabbit"
                    ))
                    .previewContext(WidgetPreviewContext(family: .systemMedium))
                    .previewDisplayName("Medium Widget")
                    
                    NiceBabyWidgetEntryView(entry: NiceBabyEntry(
                        date: Date(),
                        hearts: 2.0,
                        equippedBaby: "NiceBaby_Monkey"
                    ))
                    .previewContext(WidgetPreviewContext(family: .systemLarge))
                    .previewDisplayName("Large Widget")

                    
                }
            }
            
        }
    
