import WidgetKit
import SwiftUI
import os

private let logger = Logger(subsystem: "com.nicebabies", category: "NiceBabyWidget")

struct NiceBabyEntry: TimelineEntry {
    let date: Date
    let hearts: Double
    let equippedBaby: String
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
        
        // create timeline that updates every minute to catch changes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: Date()) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        logger.debug("Widget Timeline - Next update scheduled for: \(nextUpdate)")
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
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
            } else {
                Image("half_heart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
            }
        }
    }
}

struct NiceBabyWidgetEntryView: View {
    var entry: NiceBabyEntry
    @Environment(\.widgetFamily) var family
    
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
    
    func smallWidget(in geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        let heartSize = min(width, height) * 0.15
        
        return VStack(spacing: height * 0.02) {
            Image(spriteName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width * 0.8, height: height * 0.6)
            
            HStack(spacing: width * 0.02) {
                ForEach(0..<5) { index in
                    HeartView(index: index, heartCount: entry.hearts, size: heartSize)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func mediumWidget(in geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        let heartSize = min(width, height) * 0.12
        
        return HStack(spacing: width * 0.04) {
            Image(spriteName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width * 0.45)
            
            VStack(spacing: height * 0.04) {
                HStack(spacing: width * 0.02) {
                    ForEach(0..<5) { index in
                        HeartView(index: index, heartCount: entry.hearts, size: heartSize)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.trailing, width * 0.04)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func largeWidget(in geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        let heartSize = min(width, height) * 0.1
        
        return VStack(spacing: height * 0.03) {
            Image(spriteName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: height * 0.6)
                .padding(.top, height * 0.05)
            
            HStack(spacing: width * 0.02) {
                ForEach(0..<5) { index in
                    HeartView(index: index, heartCount: entry.hearts, size: heartSize)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@main
struct NiceBabyWidget: Widget {
    private let kind = "NiceBabyWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NiceBabyProvider()) { entry in
            NiceBabyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("NiceBaby Status")
        .description("Shows your NiceBaby's current status and hearts.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
