import WidgetKit
import SwiftUI
import os

private let logger = Logger(subsystem: "com.nicebabies.nicebabiesworld", category: "NiceBabiesWidget")

struct NiceBabiesEntry: TimelineEntry {
    let date: Date
    let hearts: Double
    let equippedBaby: String
}

extension Color {
    static let backgroundColor = Color(red: 0.78823529412, green: 0.81960784314, blue: 0.80784313725)
    static let darkGray = Color(red: 0.156862745, green: 0.152941176, blue: 0.152941176)
    static let lightGray = Color(red: 0.435294118, green: 0.431372549, blue: 0.431372549)
}

struct NiceBabiesProvider: TimelineProvider {
    let defaults = UserDefaults(suiteName: "group.nicebabies") ?? UserDefaults.standard
    func placeholder(in context: Context) -> NiceBabiesEntry {
        logger.debug("Widget Placeholder called")
        return NiceBabiesEntry(date: Date(), hearts: 5.0, equippedBaby: "NiceBaby_Monkey")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (NiceBabiesEntry) -> Void) {
        let hearts = defaults.double(forKey: "hearts")
        let equippedBaby = defaults.string(forKey: "equippedBaby") ?? "NiceBaby_Monkey"
        
        logger.debug("Widget Snapshot - Reading from shared UserDefaults")
        logger.debug("Widget Snapshot - Hearts: \(hearts)")
        logger.debug("Widget Snapshot - EquippedBaby: \(equippedBaby)")
        
        let entry = NiceBabiesEntry(date: Date(), hearts: hearts, equippedBaby: equippedBaby)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<NiceBabiesEntry>) -> Void) {
        // read from shared defaults
        let hearts = defaults.double(forKey: "hearts")
        let equippedBaby = defaults.string(forKey: "equippedBaby") ?? "NiceBaby_Monkey"
        
        logger.debug("Widget Timeline - Reading from shared UserDefaults")
        logger.debug("Widget Timeline - Hearts: \(hearts)")
        logger.debug("Widget Timeline - EquippedBaby: \(equippedBaby)")
        
        let entry = NiceBabiesEntry(date: Date(), hearts: hearts, equippedBaby: equippedBaby)
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
                    .frame(width: size * 1.9, height: size * 2)
                    .scaleEffect(size * 0.15)
                
            } else {
                Image("half_heart")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size * 1.1, height: size * 2)
                    .scaleEffect(size * 0.16)
            }
        }
    }
}

struct NiceBabiesWidgetEntryView: View {
    var entry: NiceBabiesEntry
    @Environment(\.widgetFamily) var family
    
    //these funcs are to individually fine-tune, it is then passed in to a leading padding modifier
    func getSpriteLeadingPadding(width: CGFloat) -> CGFloat {
        switch spriteName {
        case let name where name.contains("NiceBaby_Panda_Sprite_Neutral"):
            return width * 0.25
        case let name where name.contains("NiceBaby_Monkey_Sprite_Neutral"):
            return width * 0.25
        case let name where name.contains("NiceBaby_Fish_Sprite_Happy"):
            return width * 0.07
        case let name where name.contains("NiceBaby_Fish_Sprite_Neutral"):
            return width * 0.12
        case let name where name.contains("NiceBaby_Fish_Sprite_Sad"):
            return width * 0.03
        case let name where name.contains("NiceBaby_Rabbit_Sprite_Sad"):
            return width * 0.015
        default:
            return 0
        }
    }
    
    func getSpriteTrailingPadding(width: CGFloat) -> CGFloat {
        switch spriteName {
        case let name where name.contains("NiceBaby_Panda_Sprite_Happy"):
            return width * 0.18
        case let name where name.contains("NiceBaby_Rabbit_Sprite_Neutral"):
            return width * 0.05
        case let name where name.contains("NiceBaby_Monkey_Sprite_Sad"):
            return width * 0.035
        default:
            return 0
        }
    }
    
    func getSpriteScaleEffect(width: CGFloat, view: String) -> CGFloat {
        switch (spriteName, view) {
        case let (name, view) where name.contains("NiceBaby_Monkey_Sprite_Sad") && view == "small":
            return width * 0.0095
        case let (name, view) where name.contains("NiceBaby_Monkey_Sprite_Happy") && view == "small":
            return width * 0.0125
        case let (name, view) where name.contains("NiceBaby_Monkey_Sprite_Neutral") && view == "small":
            return width * 0.0138
        case let (name, view) where name.contains("NiceBaby_Fish") && view == "small":
            return width * 0.012
        case let (name, view) where name.contains("NiceBaby_Rabbit_Sprite_Sad") && view == "small":
            return width * 0.023
        case let (name, view) where name.contains("NiceBaby_Rabbit_Sprite_Neutral") && view == "small":
            return width * 0.02
        case let (name, view) where name.contains("NiceBaby_Rabbit_Sprite_Happy") && view == "small":
            return width * 0.02
        case let (name, view) where name.contains("NiceBaby_Panda") && view == "small":
            return width * 0.014
        case let (name, view) where name.contains("NiceBaby_Monkey_Sprite_Sad") && view == "large":
            return width * 0.0038
        case let (name, view) where name.contains("NiceBaby_Rabbit") && view == "large":
            return width * 0.01
        default:
            return width * 0.006
        }
    }
    
    
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
            VStack(spacing: height * 0.001) {
                HStack(spacing: width * 0.01) {
                    ForEach(0..<5) { index in
                        HeartView(index: index, heartCount: entry.hearts, size: heartSize)
                    }
                }
                .padding(.top, height * 0.05)
                
                Spacer()
                
                Image(spriteName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: width * 0.6, maxHeight: height * 0.5)
                    .scaleEffect(getSpriteScaleEffect(width: width, view: "small"))
                    .padding(.leading, getSpriteLeadingPadding(width: width))
                    .padding(.trailing, getSpriteTrailingPadding(width: width))
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .containerBackground(for: .widget) {
            Color.white
        }
    }
    
    //MEDIUM
    func mediumWidget(in geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        let heartSize = min(width, height) * 0.09
        
        return ZStack {
            VStack(spacing: height * 0.1) {
                // Hearts at the top
                HStack(spacing: width * 0.08) {
                    ForEach(0..<5) { index in
                        HeartView(index: index, heartCount: entry.hearts, size: heartSize * 1.2)
                    }
                }
                // sprite image
                Image(spriteName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(getSpriteScaleEffect(width: width, view: "medium"))
                    .padding(.leading, getSpriteLeadingPadding(width: width))
                    .padding(.trailing, getSpriteTrailingPadding(width: width))
                
                //Spacer() // Push content up to account for bottom border area
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .containerBackground(for: .widget) {
            Color.white
        }
    }
    
    
    //LARGE
    func largeWidget(in geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        let heartSize = min(width, height) * 0.055
        
        return ZStack {
            VStack(spacing: height * 0.001) {
                HStack(spacing: width * 0.058) {
                    ForEach(0..<5) { index in
                        HeartView(index: index, heartCount: entry.hearts, size: heartSize)
                    }
                }
                .padding(.top, height * 0.09)
                
                Spacer()
                
                Image(spriteName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: width * 0.95, maxHeight: height * 0.4)
                    .scaleEffect(getSpriteScaleEffect(width: width, view: "large"))
                    .padding(.leading, getSpriteLeadingPadding(width: width))
                    .padding(.trailing, getSpriteTrailingPadding(width: width))
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .containerBackground(for: .widget) {
            Color.white
        }
    }
}



@main
struct NiceBabiesWidget: Widget {
    private let kind = "NiceBabiesWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NiceBabiesProvider()) { entry in
            NiceBabiesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("NiceBaby Status")
        .description("See your baby's current mood!")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
        
//PREVIEWS
struct NiceBabiesWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NiceBabiesWidgetEntryView(entry: NiceBabiesEntry(
                date: Date(),
                hearts: 5.0,
                equippedBaby: "NiceBaby_Rabbit"
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            NiceBabiesWidgetEntryView(entry: NiceBabiesEntry(
                date: Date(),
                hearts: 3.5,
                equippedBaby: "NiceBaby_Monkey"
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            NiceBabiesWidgetEntryView(entry: NiceBabiesEntry(
                date: Date(),
                hearts: 5.0,
                equippedBaby: "NiceBaby_Panda"
            ))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
