import Cephei
import UIKit

class TweakPreferences {
    static let shared = TweakPreferences()
    
    let preferences = HBPreferences(identifier: "net.sourceloc.pinanimpreferences")
    var enabled: ObjCBool = true
    var transitionRaw: AnyObject? = "Ease Out" as AnyObject
    var animationRaw: AnyObject? = "Bounce" as AnyObject
    var animationStrength: Double = 1
    var speed: Double = 1
    var waveOnUnlock: ObjCBool = true
    var bounceDownOnDelete: ObjCBool = true
    
    private init() {
        preferences.register(defaults: [
            "enabled" : true,
            "transition" : "Ease Out",
            "animation" : "Bounce",
            "animationStrength" : 1.0,
            "speed" : 1.0,
            "waveOnUnlock" : true,
            "bounceDownOnDelete" : true,
        ])
        preferences.register(&enabled, default: true, forKey: "enabled")
        preferences.register(&transitionRaw, default: "Ease Out", forKey: "transition")
        preferences.register(&animationRaw, default: "Bounce", forKey: "animation")
        preferences.register(&animationStrength, default: 1.0, forKey: "animationStrength")
        preferences.register(&speed, default: 1.0, forKey: "speed")
        preferences.register(&waveOnUnlock, default: true, forKey: "waveOnUnlock")
        preferences.register(&bounceDownOnDelete, default: true, forKey: "bounceDownOnDelete")
    }

    private func getTransitionOptionFromRaw(_ str: String) -> UIView.AnimationOptions { 
        switch str {
        case "Ease Out":
            return .curveEaseOut
        case "Ease In":
            return .curveEaseOut
        case "Ease In Out":
            return .curveEaseInOut
        case "Linear":
            return .curveLinear
        default:
            fatalError("Unknown getTransitionOptionFromRaw option")
        }
    }
    private func getAnimationFromRaw(_ str: String) -> PinAnimation { 
        switch str {
        case "Bounce":
            return .bounce
        case "Scale":
            return .scale
        case "Stay":
            return .stay
        case "Hidden":
            return .hidden
        default:
            return .unknown
        }
    }

    var transition: UIView.AnimationOptions {
        getTransitionOptionFromRaw(transitionRaw as! String)
    }
    var animation: PinAnimation {
        getAnimationFromRaw(animationRaw as! String)
    }


    enum PinAnimation {
        case bounce, scale, stay, hidden, unknown
    }
}
