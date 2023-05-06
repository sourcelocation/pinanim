import SwiftUI

struct RootView: View {
    @StateObject private var preferenceStorage = PreferenceStorage()
    
    var body: some View {
        Form {
            Section {
                Toggle("Enabled", isOn: $preferenceStorage.isEnabled)
            } header: {
                Text("General")
            }
            
            Section {
                Picker("Animation", selection: $preferenceStorage.animation) {
                    Text("Bounce").tag("bounce")
                    Text("Scale").tag("scale")
                    Text("Hidden").tag("hidden")
                    Text("Stay").tag("stay")
                }
                .pickerStyle(.segmented)
                
                Toggle("Unlock Animation", isOn: $preferenceStorage.waveOnUnlock)
                Toggle("Deletion Animation", isOn: $preferenceStorage.bounceDownOnDelete)
                Text("Apmlification:")
                HStack {
                    Slider(value: $preferenceStorage.animationStrength, in: -200...200)
                    Text("\(Int(preferenceStorage.animationStrength))%")
                        .frame(width: 48)
                }
                Text("Speed:")
                HStack {
                    Slider(value: $preferenceStorage.speed, in: -250...250)
                    Text("\(Int(preferenceStorage.speed))%")
                        .frame(width: 48)
                }
            } header: {
                Text("Animation")
            }
            
            Section {
                Picker("Transition", selection: $preferenceStorage.transition) {
                    Text("Ease Out").tag("easeOut")
                    Text("Ease In").tag("easeIn")
                    Text("Ease In Out").tag("easeInOut")
                    Text("Linear").tag("linear")
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Transition")
            }
            Section {
                Picker("hapticFeedback", selection: $preferenceStorage.hapticFeedback) {
                    Text("Light").tag(UIImpactFeedbackGenerator.FeedbackStyle.light.rawValue)
                    Text("Medium").tag(UIImpactFeedbackGenerator.FeedbackStyle.medium.rawValue)
                    Text("Heavy").tag(UIImpactFeedbackGenerator.FeedbackStyle.heavy.rawValue)
                    Text("Soft").tag(UIImpactFeedbackGenerator.FeedbackStyle.soft.rawValue)
                    Text("Rigid").tag(UIImpactFeedbackGenerator.FeedbackStyle.rigid.rawValue)
                }
                .pickerStyle(.segmented)
                .onChange(of: preferenceStorage.hapticFeedback) { newValue in
                    UIImpactFeedbackGenerator(style: .init(rawValue: newValue)!).impactOccurred()
                }
            } header: {
                Text("Haptic Feedback (Vibration)")
            }
            
            Section {
                Link(destination: URL(string: "https://github.com/sourcelocation")!) {
                    HStack {
//                        Image("github", bundle: Bundle.prefs)
//                            .renderingMode(.template)
//                            .resizable()
//                            .frame(width: 32, height: 32)
//                            .foregroundColor(.white)
                        Text("Source Code")
                    }
                }
            } header: {
                Text("Links!")
            }
        }
        .accentColor(.green)
        .toggleStyle(SwitchToggleStyle(tint: .green))
    }
}
