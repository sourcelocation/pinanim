import Orion
import PinAnimC

class PasscodeDotHook: ClassHook<SBSimplePasscodeEntryFieldButton> {
    func setRevealed(_ revealed: Bool, animated: Bool, delay: CGFloat) {
        guard TweakPreferences.shared.enabled.boolValue && TweakPreferences.shared.preferences.bool(forKey: "preferencesShown") else { orig.setRevealed(revealed, animated: animated, delay: delay); return }
        orig.setRevealed(revealed, animated: TweakPreferences.shared.animation == .hidden ? false : animated, delay: delay)
        target.superview?.superview?.superview?.superview?.clipsToBounds = false
        if !(TweakPreferences.shared.waveOnUnlock.boolValue && dotI() == dotCount() - 1) {
            animate(!revealed)
        }
    }

    func layoutSubviews() {
        orig.layoutSubviews()
        guard TweakPreferences.shared.enabled.boolValue && TweakPreferences.shared.preferences.bool(forKey: "preferencesShown") else { return }
        if TweakPreferences.shared.animation == .hidden && !Ivars<Bool>(target)._revealed {
            target.alpha = 0
        }
    }

    // orion:new
    func animate(_ deletion: Bool) {
        if TweakPreferences.shared.animation == .stay && dotI() != dotCount() - 1 {
            if deletion {
                self.target.transform = .init(translationX: 0, y: -10 * TweakPreferences.shared.animationStrength)
            } else {
                self.target.transform = .init(translationX: 0, y: 0)
            }
        }
        UIView.animate(withDuration: 0.15 / TweakPreferences.shared.speed, delay: 0, options: TweakPreferences.shared.transition, animations: { [weak self] in
            switch TweakPreferences.shared.animation {
            case .bounce, .stay:
                let animationK = (deletion ? (TweakPreferences.shared.bounceDownOnDelete.boolValue ? -1.0 : 0.0) : 1.0)
                if TweakPreferences.shared.animation == .stay && deletion {
                    self?.target.transform = .init(translationX: 0, y: 0)
                } else {
                    self?.target.transform = .init(translationX: 0, y: -10 * TweakPreferences.shared.animationStrength * animationK)
                }
            case .hidden:
                self?.target.alpha = deletion ? 0 : 1
            case .scale:
                let dotScale = TweakPreferences.shared.animationStrength * (deletion ? (TweakPreferences.shared.bounceDownOnDelete.boolValue ? 0.7 : 1) : 0.4)
                self?.target.transform = .init(scaleX: dotScale, y: dotScale)
            default: break
            }
        }, completion: { animationCompleted in
            guard TweakPreferences.shared.animation != .stay && animationCompleted else { return }
            UIView.animate(withDuration: 0.15 / TweakPreferences.shared.speed, delay: 0, options: TweakPreferences.shared.transition, animations: { [weak self] in
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

        guard TweakPreferences.shared.enabled.boolValue &&
            TweakPreferences.shared.preferences.bool(forKey: "preferencesShown") && 
            TweakPreferences.shared.waveOnUnlock.boolValue else { return }

        let keypad = Dynamic.convert(arg1, to: SBUIPasscodeLockViewSimpleFixedDigitKeypad.self)

        for s1 in keypad.subviews {
            for s2 in s1.subviews {
                if let entryField = s2 as? SBUISimpleFixedDigitPasscodeEntryField {
                    let dots = Ivars<NSMutableArray>(entryField)._characterIndicators as! [SBSimplePasscodeEntryFieldButton]
                    if Ivars<Bool>(dots.last!)._revealed {
                        for (i,dot) in dots.enumerated() {
                            dot.transform = CGAffineTransform(scaleX: 1, y: 1)
                            dot.layer.removeAllAnimations()
                            dot.animate((TweakPreferences.shared.animation == .stay || TweakPreferences.shared.animation == .hidden) ? true : false)
                        }
                    }
                }
            }
        } 
    }
}

class SpringBoardHook: ClassHook<SpringBoard> {
    func applicationDidFinishLaunching(_ application : AnyObject) {
        orig.applicationDidFinishLaunching(application)
        
        if !TweakPreferences.shared.preferences.bool(forKey: "preferencesShown") {
            let alert = UIAlertController(title: "PinAnim installed! 🎉", message: "Please go to Settings to enable the tweak", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            UIApplication.shared.windows[0].rootViewController?.present(alert, animated: true)
        }
    }
}
