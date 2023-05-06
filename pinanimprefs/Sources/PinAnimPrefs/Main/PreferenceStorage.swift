import Foundation
import Comet
import Combine

// MARK: - Internal

final class PreferenceStorage: ObservableObject {
    
    static var shared = PreferenceStorage()
    
    private static let registry: String = "/var/mobile/Library/Preferences/net.sourceloc.pinanim.prefs.plist"
    
    @Published(key: "enabled", registry: registry) var isEnabled = true
    @Published(key: "animation", registry: registry) var animation = "bounce"
    @Published(key: "transition", registry: registry) var transition = "easeOut"
    @Published(key: "waveOnUnlock", registry: registry) var waveOnUnlock = true
    @Published(key: "hapticFeedback", registry: registry) var hapticFeedback = UIImpactFeedbackGenerator.FeedbackStyle.light.rawValue
    @Published(key: "bounceDownOnDelete", registry: registry) var bounceDownOnDelete = true
    @Published(key: "animationStrength", registry: registry) var animationStrength = 100.0
    @Published(key: "speed", registry: registry) var speed = 100.0
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.objectWillChange
            .sink { _ in
                remLog("updated")
                let center = CFNotificationCenterGetDarwinNotifyCenter()
                let name = "net.sourceloc.pinanim.prefs/Update" as CFString
                let object = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
                CFNotificationCenterPostNotification(center, .init(name), object, nil, true)
            }
            .store(in: &cancellables)
    }
}
