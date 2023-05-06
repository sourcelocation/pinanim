import SwiftUI
import Comet
import PinAnimPrefsC

class RootListController: CMViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup(content: RootView())
        self.title = "PinAnim"
    }
}
