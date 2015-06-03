import UIKit
import AVKit
import AVFoundation

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
    
    func initVideo() {
        var video = UIView(frame: self.view.frame)
        self.view.addSubview(video)
        self.view.sendSubviewToBack(video)
        videoManager.savedCallback = savedVideo
        videoManager.celebName = celebName
        videoManager.setup()
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
    
    func playVideo() {
        
    }
    
    private func startRecording() {
        videoManager.done()
        backButton!.enabled = false
    }
    
    private func stopRecording() {
        videoManager.done()
        processingModal?.hidden = false
        activityIndicator?.startAnimating()
        backButton!.enabled = true
    }
    
    private func savedVideo(url: NSURL) {
        videoURL = url
        processingModal?.hidden = true
        activityIndicator?.stopAnimating()
        doneModal?.hidden = false
        
        performSegueWithIdentifier("playVideo", sender: self)
    }
}