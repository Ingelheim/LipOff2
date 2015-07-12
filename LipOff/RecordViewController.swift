import UIKit
import AVKit
import AVFoundation
import Parse

class RecordViewController: TGTMViewController {
    var videoManager = VideoManager()
    var doneModal : UIImageView?
    var activityIndicator : UIActivityIndicatorView?
    var processingModal : UIImageView?
    var videoURL : NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton?.recordStartCallback = startRecording
        recordButton?.recordDoneCallback = stopRecording
        initVideo()
        createProcessingModal()
        createDoneModal()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        changeCelebName()
        sendCelebritySelected(selectedTile)
    }
    
    func initVideo() {
        var video = UIView(frame: self.view.frame)
        self.view.addSubview(video)
        self.view.sendSubviewToBack(video)
        videoManager.savedCallback = savedVideo
        videoManager.setup()
        videoManager.selectedTile = self.selectedTile
        videoManager.startCapturing()
        var previewLayer = AVCaptureVideoPreviewLayer(session: videoManager.captureSession)
        video.layer.addSublayer(previewLayer)
        previewLayer?.frame = video.layer.frame
    }
    
    func dissmissModal() {
        doneModal?.hidden = true
        self.goBackToSelection()
    }
    
    private func createDoneModal() {
        doneModal = UIImageView(frame: self.view.frame)
        doneModal!.image = UIImage(named: "Modal")
        
        doneModal?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dissmissModal")))
        doneModal!.hidden = true
        doneModal?.userInteractionEnabled = true
        
        self.view.addSubview(doneModal!)
    }
    
    private func createProcessingModal() {
        processingModal = UIImageView(frame: self.view.frame)
        processingModal!.image = UIImage(named: "Processing")
        processingModal?.userInteractionEnabled = false
        processingModal!.hidden = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicator!.hidesWhenStopped = true
        activityIndicator!.frame = processingModal!.frame
        processingModal?.addSubview(activityIndicator!)
        
        self.view.addSubview(processingModal!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
            if (segue.identifier == "playVideo") {
                let destination = segue.destinationViewController as!
                VideoPlayer
                destination.showsPlaybackControls = true
                destination.player = AVPlayer(URL: videoURL)
            }
    }
    
    func goToCC() {
        performSegueWithIdentifier("creativeCommons", sender: self)
    }
    
    private func startRecording() {
        videoManager.done()
        backButton!.enabled = false
        sendVideoStarted(selectedTile)
    }
    
    private func stopRecording(secondsLeft: Int) {
        videoManager.done()
        processingModal?.hidden = false
        activityIndicator?.startAnimating()
        backButton!.enabled = true
        sendVideoRecorded(selectedTile, secondsLeft: secondsLeft)
    }
    
    private func savedVideo(url: NSURL) {
        videoURL = url
        processingModal?.hidden = true
        activityIndicator?.stopAnimating()
        doneModal?.hidden = false
        sendVideoSaved(selectedTile)
        
        performSegueWithIdentifier("playVideo", sender: self)
    }
    
    private func sendCelebritySelected(position : TILE_POSITION) {
        PFAnalytics.trackEventInBackground("celebritySelected", dimensions: ["tilePosition" :"\(position.rawValue)"], block: nil)
    }
    
    private func sendVideoStarted(position : TILE_POSITION) {
        PFAnalytics.trackEventInBackground("videoStarted", dimensions: ["tilePosition" : "\(position.rawValue)"], block: nil)
    }
    
    private func sendVideoRecorded(position : TILE_POSITION, secondsLeft : Int) {
        PFAnalytics.trackEventInBackground("videoRecorded", dimensions: ["tilePosition" : "\(position.rawValue)", "secondsLeft" : "\(secondsLeft)"], block: nil)
    }
    
    private func sendVideoSaved(position : TILE_POSITION) {
        PFAnalytics.trackEventInBackground("videoSaved", dimensions: ["tilePosition" : "\(position.rawValue)"], block: nil)
    }
}