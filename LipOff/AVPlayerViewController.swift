import UIKit
import AVFoundation
import AVKit

class VideoPlayer : AVPlayerViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.player.play()
    }
}