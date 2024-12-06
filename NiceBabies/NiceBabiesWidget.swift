/*import WidgetKit
import FirebaseCore
import SwiftUI
import os

private let logger = Logger(subsystem: "com.nicebabies.nicebabiesworld", category: "NiceBabiesWidget")

struct NiceBabiesProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> NiceBabiesEntry {
        logger.debug("Widget Placeholder called")
        return NiceBabiesEntry(date: Date(), hearts: 5.0, equippedBaby: "NiceBaby_Monkey")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (NiceBabiesEntry) -> Void) {
        logger.debug("Widget Snapshot - Reading from shared container")
        
        let hearts = SharedContainer.container?.double(forKey: SharedContainer.Keys.hearts)
        let equippedBaby = SharedContainer.container?.string(forKey: SharedContainer.Keys.equippedBaby)
        
        logger.debug("Widget Snapshot - Hearts: \(String(describing: hearts))")
        logger.debug("Widget Snapshot - EquippedBaby: \(String(describing: equippedBaby))")
        
        let entry = NiceBabiesEntry(
            date: Date(),
            hearts: hearts ?? 5.0,
            equippedBaby: equippedBaby ?? "NiceBaby_Monkey"
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<NiceBabiesEntry>) -> Void) {
        logger.debug("Widget Timeline - Reading from shared container")
        
        let hearts = SharedContainer.container?.double(forKey: SharedContainer.Keys.hearts)
        let equippedBaby = SharedContainer.container?.string(forKey: SharedContainer.Keys.equippedBaby)
        
        logger.debug("Widget Timeline - Hearts: \(String(describing: hearts))")
        logger.debug("Widget Timeline - EquippedBaby: \(String(describing: equippedBaby))")
        
        let entry = NiceBabiesEntry(
            date: Date(),
            hearts: hearts ?? 5.0,
            equippedBaby: equippedBaby ?? "NiceBaby_Monkey"
        )
        
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
}

struct NiceBabiesEntry: TimelineEntry {
    let date: Date
    let hearts: Double
    let equippedBaby: String
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
    func getSpriteLeadingPadding(width: CGFloat, view: String) -> CGFloat {
        switch (spriteName, view) {
        case let (name,view) where name.contains("NiceBaby_Monkey_Sprite_Neutral") && view == "small" || view == "large":
            return width * 0.2
        case let (name, view) where name.contains("NiceBaby_Fish_Sprite_Happy") && view == "small":
            return width * 0.1
        case let (name,view) where name.contains("NiceBaby_Monkey_Sprite_Neutral") && view == "medium":
            return width * 0.07
        case let (name,view) where name.contains("NiceBaby_Panda_Sprite_Neutral") && view == "medium":
            return width * 0.03
        default:
            return 0
        }
    }
    
    func getSpriteTrailingPadding(width: CGFloat, view: String) -> CGFloat {
        switch (spriteName, view) {
        case let (name, view) where name.contains("NiceBaby_Panda_Sprite_Happy") && view == "small":
            return width * 0.15
        case let (name, view) where name.contains("NiceBaby_Panda_Sprite_Happy") && view == "medium":
            return width * 0.1
        case let (name,view) where name.contains("NiceBaby_Panda_Sprite_Neutral") && view == "large":
            return width * 0.35
        case let (name, view) where name.contains("NiceBaby_Monkey_Sprite_Sad") && view == "large":
            return width * 0.2
        case let (name, view) where name.contains("NiceBaby_Monkey_Sprite_Happy") && view == "large":
            return width * 0.2
        case let (name, view) where name.contains("NiceBaby_Fish_Sprite_Happy") && view == "large":
            return width * 0.15
        case let (name,view) where name.contains("NiceBaby_Panda_Sprite_Sad") && view == "large":
            return width * 0.2
        case let (name, view) where name.contains("NiceBaby_Panda_Sprite_Happy") && view == "large":
            return width * 0.35
        case let (name, view) where name.contains("NiceBaby_Fish_Sprite_Sad") && view == "large":
            return width * 0.15
        case let (name, view) where name.contains("NiceBaby_Fish_Sprite_Neutral") && view == "large":
            return width * 0.1
        case let (name, view) where name.contains("NiceBaby_Rabbit_Sprite") && view == "large":
            return width * 0.17
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
        case let (name, view) where name.contains("NiceBaby_Panda_Sprite_Happy") && view == "small":
            return width * 0.014
        case let (name, view) where name.contains("NiceBaby_Panda_Sprite_Neutral") && view == "small":
            return width * 0.012
        case let (name, view) where name.contains("NiceBaby_Panda_Sprite_Sad") && view == "small":
            return width * 0.014
        case let (name, view) where name.contains("NiceBaby_Fish") && view == "medium":
            return width * 0.007
        case let (name, view) where name.contains("NiceBaby_Monkey_Sprite_Happy") && view == "medium":
            return width * 0.0076
        case let (name, view) where name.contains("NiceBaby_Monkey_Sprite_Sad") && view == "medium":
            return width * 0.0047
        case let (name, view) where name.contains("NiceBaby_Panda") && view == "medium":
            return width * 0.0065
        case let (name, view) where name.contains("NiceBaby_Monkey_Sprite_Neutral") && view == "medium":
            return width * 0.00788
        case let (name, view) where name.contains("NiceBaby_Monkey_Sprite_Sad") && view == "medium":
            return width * 0.0047
        case let (name, view) where name.contains("NiceBaby_Monkey_Sprite_Sad") && view == "large":
            return width * 0.0038
        case let (name, view) where name.contains("NiceBaby_Panda") && view == "large":
            return width * 0.006
        case let (name, view) where name.contains("NiceBaby_Fish") && view == "large":
            return width * 0.0045
        case let (name, view) where name.contains("NiceBaby_Rabbit") && view == "large" || view == "medium":
            return width * 0.01
        case let (name, view) where name.contains("NiceBaby_Monkey") && view == "large":
            return width * 0.005
        default:
            return width * 0.006
        }
    }

    /*func getBackgroundView(geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        
        let baseName: String = switch spriteState {
        case "Happy":   "Happy_Background"
        case "Neutral": "Neutral_Background"
        case "Sad":     "Sad_Background"
        default:        "Neutral_Background"
        }
        
        return Image(baseName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .grayscale(0.5)
    }*/
    
    func getBackgroundView(geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        
        // Determine the base name based on spriteState
        let baseName: String
        switch spriteState {
        case "Happy":
            baseName = "Happy_Background"
        case "Neutral":
            baseName = "Neutral_Background"
        case "Sad":
            baseName = "Sad_Background"
        default:
            baseName = "Neutral_Background"
        }
        
        return Image(baseName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .grayscale(0.5)
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
                    .widgetURL(URL(string: "nicebabies://dollstatus"))
            case .systemMedium:
                mediumWidget(in: geometry)
                    .widgetURL(URL(string: "nicebabies://dollstatus"))
            case .systemLarge:
                largeWidget(in: geometry)
                    .widgetURL(URL(string: "nicebabies://dollstatus"))
            default:
                smallWidget(in: geometry)
                    .widgetURL(URL(string: "nicebabies://dollstatus"))

            }
        }
    }
        
    func smallWidget(in geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        let heartSize = min(width, height) * 0.09
        
        return ZStack {
            
            getBackgroundView(geometry: geometry)
                .ignoresSafeArea()
                .zIndex(-1) // Ensure it is behind other content
            
            VStack(spacing: height * 0.001) {
                HStack(spacing: width * 0.01) {
                    ForEach(0..<5) { index in
                        HeartView(index: index, heartCount: entry.hearts, size: heartSize)
                    }
                }
                .padding(.top, height * 0.05)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Image(spriteName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: width * 0.6, maxHeight: height * 0.5)
                        .scaleEffect(getSpriteScaleEffect(width: width, view: "small"))
                        .padding(.leading, getSpriteLeadingPadding(width: width, view: "small"))
                        .padding(.trailing, getSpriteTrailingPadding(width: width, view: "small"))

                    Spacer()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

    }
    
    func mediumWidget(in geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        let heartSize = min(width, height) * 0.09
        
        return ZStack {
            
            getBackgroundView(geometry: geometry)
                .ignoresSafeArea()
                .zIndex(-1) // Ensure it is behind other content
            VStack(spacing: height * 0.06) {
                HStack(spacing: width * 0.058) {
                    ForEach(0..<5) { index in
                        HeartView(index: index, heartCount: entry.hearts, size: heartSize * 1.2)
                    }
                }
                .padding(.top, height * 0.085)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Image(spriteName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: width * 0.95, maxHeight: height * 0.4)
                        .scaleEffect(getSpriteScaleEffect(width: width, view: "medium"))
                        .padding(.leading, getSpriteLeadingPadding(width: width, view: "medium"))
                        .padding(.trailing, getSpriteTrailingPadding(width: width, view: "medium"))
                        .padding(.top, -height * 0.7) // Move the image up
                    Spacer()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

    }
    
    func largeWidget(in geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        let heartSize = min(width, height) * 0.055
        
        return ZStack {
            
            getBackgroundView(geometry: geometry)
                .ignoresSafeArea()
                .zIndex(-1) // Ensure it is behind other content
            VStack(spacing: height * 0.001) {
                HStack(spacing: width * 0.058) {
                    ForEach(0..<5) { index in
                        HeartView(index: index, heartCount: entry.hearts, size: heartSize)
                    }
                }
                .padding(.top, height * 0.09)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Image(spriteName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: width * 0.6, maxHeight: height * 0.5)
                        .scaleEffect(getSpriteScaleEffect(width: width, view: "large"))
                        .padding(.leading, getSpriteLeadingPadding(width: width, view: "large"))
                        .padding(.trailing, getSpriteTrailingPadding(width: width, view: "large"))

                    Spacer()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

    }
}
    
    @main
    struct NiceBabiesWidget: Widget {
        private let kind = "NiceBabiesWidget"
        
        init() {
            //setup firebase
            FirebaseApp.configure()
        }
        
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
                    hearts: 1.5,
                    equippedBaby: "NiceBaby_Fish"
                ))
                .previewContext(WidgetPreviewContext(family: .systemSmall))

                
                NiceBabiesWidgetEntryView(entry: NiceBabiesEntry(
                    date: Date(),
                    hearts: 1.5,
                    equippedBaby: "NiceBaby_Monkey"
                ))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                
                NiceBabiesWidgetEntryView(entry: NiceBabiesEntry(
                    date: Date(),
                    hearts: 1.5,
                    equippedBaby: "NiceBaby_Panda"
                ))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            }
        }
    }*/

import WidgetKit
import FirebaseCore
import SwiftUI
import os

private let logger = Logger(subsystem: "com.nicebabies.nicebabiesworld", category: "NiceBabiesWidget")

struct NiceBabiesProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> NiceBabiesEntry {
        logger.debug("Widget Placeholder called")
        return NiceBabiesEntry(date: Date(), hearts: 5.0, equippedBaby: "NiceBaby_Monkey")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (NiceBabiesEntry) -> Void) {
        logger.debug("Widget Snapshot - Fetching data from Firestore")
        fetchWidgetData { entry in
            completion(entry ?? NiceBabiesEntry(date: Date(), hearts: 5.0, equippedBaby: "NiceBaby_Monkey"))
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<NiceBabiesEntry>) -> Void) {
        logger.debug("Widget Timeline - Fetching data from Firestore")
        fetchWidgetData { entry in
            let timelineEntry = entry ?? NiceBabiesEntry(date: Date(), hearts: 5.0, equippedBaby: "NiceBaby_Monkey")
            
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
            let timeline = Timeline(entries: [timelineEntry], policy: .after(nextUpdate))
            
            completion(timeline)
        }
    }
    
    /// Helper method to fetch `currentHearts` and `equippedBaby` from Firestore
    private func fetchWidgetData(completion: @escaping (NiceBabiesEntry?) -> Void) {
        let group = DispatchGroup()
        var hearts: Double = 5.0
        var equippedBaby: String = "NiceBaby_Monkey"
        
        // Fetch currentHearts
        group.enter()
        fetchUserData(for: "currentHearts") { value, error in
            if let error = error {
                logger.error("Error fetching currentHearts: \(error.localizedDescription)")
            } else if let fetchedHearts = value as? Double {
                hearts = fetchedHearts
            }
            group.leave()
        }
        
        // Fetch equippedBaby
        group.enter()
        fetchUserData(for: "equippedBaby") { value, error in
            if let error = error {
                logger.error("Error fetching equippedBaby: \(error.localizedDescription)")
            } else if let fetchedEquippedBaby = value as? String {
                equippedBaby = fetchedEquippedBaby
            }
            group.leave()
        }
        
        // Complete after all fetches are done
        group.notify(queue: .main) {
            let entry = NiceBabiesEntry(date: Date(), hearts: hearts, equippedBaby: equippedBaby)
            completion(entry)
        }
    }
}

struct NiceBabiesEntry: TimelineEntry {
    let date: Date
    let hearts: Double
    let equippedBaby: String
}

struct NiceBabiesWidgetEntryView: View {
    var entry: NiceBabiesEntry
    @Environment(\.widgetFamily) var family
    
    var spriteState: String {
        if entry.hearts >= 3.5 {
            return "Happy"
        } else if entry.hearts >= 2.0 {
            return "Neutral"
        } else {
            return "Sad"
        }
    }
    
    var spriteName: String {
        let baseName = entry.equippedBaby.replacingOccurrences(of: "NiceBaby_", with: "")
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
        ZStack {
            backgroundView(for: geometry)
            spriteImage(for: geometry, view: "small")
        }
    }
    
    func mediumWidget(in geometry: GeometryProxy) -> some View {
        ZStack {
            backgroundView(for: geometry)
            spriteImage(for: geometry, view: "medium")
        }
        
    }
    
    func largeWidget(in geometry: GeometryProxy) -> some View {
        ZStack {
            backgroundView(for: geometry)
            spriteImage(for: geometry, view: "large")
        }
    }
    
    func backgroundView(for geometry: GeometryProxy) -> some View {
        let baseName = {
            switch spriteState {
            case "Happy": return "Happy_Background"
            case "Neutral": return "Neutral_Background"
            case "Sad": return "Sad_Background"
            default: return "Neutral_Background"
            }
        }()
        return Image(baseName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .grayscale(0.5)
    }
    
    func spriteImage(for geometry: GeometryProxy, view: String) -> some View {
        Image(spriteName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.5)
    }
}

@main
struct NiceBabiesWidget: Widget {
    private let kind = "NiceBabiesWidget"
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NiceBabiesProvider()) { entry in
            NiceBabiesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("NiceBaby Status")
        .description("See your baby's current mood!")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct NiceBabiesWidget_Previews: PreviewProvider {
    static var previews: some View {
        NiceBabiesWidgetEntryView(entry: NiceBabiesEntry(
            date: Date(),
            hearts: 3.5,
            equippedBaby: "NiceBaby_Monkey"
        ))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}



