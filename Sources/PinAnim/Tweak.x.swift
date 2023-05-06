import Orion
import PinAnimC


final class KickStart: Tweak {
    init() {
        remLog("kickstart")
        
        do {
            try TweakPreferences.shared.loadSettings()
        } catch {
            remLog(error.localizedDescription)
        }
        
        let center = CFNotificationCenterGetDarwinNotifyCenter()
        let name = "net.sourceloc.pinanim.prefs/Update" as CFString
        let observer = UnsafeMutableRawPointer(Unmanaged.passRetained(self).toOpaque())

        CFNotificationCenterAddObserver(center, observer, { center, observer, name, object, userInfo in
            remLog("relo")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                reloadSettings()
            })
        }, name, nil, .deliverImmediately)
    }
}


func reloadSettings() {
    remLog("ReloadSettings 2")
    do {
        try TweakPreferences.shared.loadSettings()
    } catch {
        remLog("Failed to load settings: \(error)")
        remLog(error)
    }
}

class PasscodeDotHook: ClassHook<SBSimplePasscodeEntryFieldButton> {
    func setRevealed(_ revealed: Bool, animated: Bool, delay: CGFloat) {
        remLog(TweakPreferences.shared.settings.enabled)
        guard TweakPreferences.shared.settings.enabled else { orig.setRevealed(revealed, animated: animated, delay: delay); return }
        orig.setRevealed(revealed, animated: TweakPreferences.shared.settings.animation == .hidden ? false : animated, delay: delay)
        target.superview?.superview?.superview?.superview?.clipsToBounds = false
        if !(TweakPreferences.shared.settings.waveOnUnlock && dotI() == dotCount() - 1) {
            animate(!revealed)
        }
    }

    func layoutSubviews() {
        orig.layoutSubviews()
        remLog("layoutSubviews")
        guard TweakPreferences.shared.settings.enabled else { return }
        remLog(TweakPreferences.shared.settings.enabled)
        if TweakPreferences.shared.settings.animation == .hidden && !Ivars<Bool>(target)._revealed {
            target.alpha = 0
        }
    }

    // orion:new
    func animate(_ deletion: Bool) {
        if TweakPreferences.shared.settings.animation == .stay && dotI() != dotCount() - 1 {
            if deletion {
                self.target.transform = .init(translationX: 0, y: -10 * TweakPreferences.shared.settings.animationStrength / 100)
            } else {
                self.target.transform = .init(translationX: 0, y: 0)
            }
        }
        
        let animation = [
            PinTransition.easeIn : UIView.AnimationOptions.curveEaseIn,
            PinTransition.easeOut : UIView.AnimationOptions.curveEaseOut,
            PinTransition.easeInOut : UIView.AnimationOptions.curveEaseInOut,
            PinTransition.linear : UIView.AnimationOptions.curveLinear,
        ][TweakPreferences.shared.settings.transition]!
        
        UIView.animate(withDuration: 0.15 / TweakPreferences.shared.settings.speed * 100, delay: 0, options: animation, animations: { [weak self] in
            switch TweakPreferences.shared.settings.animation {
            case .bounce, .stay:
                let animationK = (deletion ? (TweakPreferences.shared.settings.bounceDownOnDelete ? -1.0 : 0.0) : 1.0)
                if TweakPreferences.shared.settings.animation == .stay && deletion {
                    self?.target.transform = .init(translationX: 0, y: 0)
                } else {
                    self?.target.transform = .init(translationX: 0, y: -10 * TweakPreferences.shared.settings.animationStrength * animationK / 100)
                }
            case .hidden:
                self?.target.alpha = deletion ? 0 : 1
            case .scale:
                let dotScale = TweakPreferences.shared.settings.animationStrength / 100 * (deletion ? (TweakPreferences.shared.settings.bounceDownOnDelete ? 0.7 : 1) : 0.4)
                self?.target.transform = .init(scaleX: dotScale, y: dotScale)
            }
        }, completion: { animationCompleted in
            guard TweakPreferences.shared.settings.animation != .stay && animationCompleted else { return }
            UIView.animate(withDuration: 0.15 / TweakPreferences.shared.settings.speed * 100, delay: 0, options: animation, animations: { [weak self] in
                self?.target.transform = .init(translationX: 0, y: 0)
            })
        })
    }

    // orion:new
    func dotI() -> Int {
        target.superview!.subviews.firstIndex(of: target)!
    }

    // orion:new
    func dotCount() -> Int {
        target.superview!.subviews.count
    }
}


class CSPasscodeViewControllerHook: ClassHook<CSPasscodeViewController> {
    func passcodeLockViewPasscodeDidChange(_ arg1: AnyObject) {
        orig.passcodeLockViewPasscodeDidChange(arg1)

        guard TweakPreferences.shared.settings.enabled &&
            TweakPreferences.shared.settings.waveOnUnlock else { return }
        
        UIImpactFeedbackGenerator(style: .init(rawValue: TweakPreferences.shared.settings.hapticFeedback)!).impactOccurred()

        let keypad = Dynamic.convert(arg1, to: SBUIPasscodeLockViewSimpleFixedDigitKeypad.self)

        for s1 in keypad.subviews {
            for s2 in s1.subviews {
                if let entryField = s2 as? SBUISimpleFixedDigitPasscodeEntryField {
                    let dots = Ivars<NSMutableArray>(entryField)._characterIndicators as! [SBSimplePasscodeEntryFieldButton]
                    if Ivars<Bool>(dots.last!)._revealed {
                        for (_,dot) in dots.enumerated() {
                            dot.transform = CGAffineTransform(scaleX: 1, y: 1)
                            dot.layer.removeAllAnimations()
                            dot.animate((TweakPreferences.shared.settings.animation == .stay || TweakPreferences.shared.settings.animation == .hidden) ? true : false)
                        }
                    }
                }
            }
        } 
    }
}
