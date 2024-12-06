import Foundation

struct SharedContainer {
    
    static let appGroup = "group.nicebabies"
    static let container = UserDefaults(suiteName: appGroup)
    
    enum Keys {
        static let equippedBaby = "equippedBaby"
        static let hearts = "hearts"
        static let lastActiveDate = "lastActiveDate"
    }
    
    
    static func updateCache(hearts: Double?, equippedBaby: String?) {
        if let hearts = hearts {
            container?.set(hearts, forKey: Keys.hearts)
        }
        if let equippedBaby = equippedBaby {
            container?.set(equippedBaby, forKey: Keys.equippedBaby)
        }
        container?.set(Date(), forKey: Keys.lastActiveDate)
        container?.synchronize()
    }
}
