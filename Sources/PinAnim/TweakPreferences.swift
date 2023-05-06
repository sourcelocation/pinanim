import Foundation
import SwiftUI
import Comet

final class TweakPreferences {
    private(set) var settings: Settings!
    static let shared = TweakPreferences()

    private let preferencesFilePath = "/var/mobile/Library/Preferences/net.sourceloc.pinanim.prefs.plist"

    func loadSettings() throws {
        remLog("loading settings")
        if let data = FileManager.default.contents(atPath: preferencesFilePath) {
            remLog(String(data: data, encoding: .utf8))
            self.settings = try PropertyListDecoder().decode(Settings.self, from: data)
            remLog(self.settings)
        } else {
            self.settings = Settings()
        }
    }
}


struct Settings: Codable {
    var enabled: Bool = true
    
    var transition: PinTransition = .easeOut
    
    var animation: PinAnimation = .bounce
    
    var animationStrength: Double = 100.0
    
    var speed: Double = 100.0
    
    var waveOnUnlock: Bool = true
    
    
    var hapticFeedback: UIImpactFeedbackGenerator.FeedbackStyle.RawValue = 0
    
    var bounceDownOnDelete: Bool = true
}



enum PinTransition: String, Codable {
    case easeOut, easeIn, easeInOut, linear
}
enum PinAnimation: String, Codable {
    case bounce, scale, hidden, stay
}
