import UIKit
import AVFoundation

class RecordViewController: TGTMViewController {
    var captureSession : TGTMCaptureSession?
    var doneModal : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton?.recordStartCallback = startRecording
        recordButton?.recordDoneCallback = stopRecording
        initVideo()
        createDoneModal()
    }
    
    func initVideo() {
        var video = UIView(frame: self.view.frame)
        captureSession = TGTMCaptureSession()
        captureSession!.parent = self
        
        self.view.addSubview(video)
        self.view.sendSubviewToBack(video)
        
        var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        video.layer.addSublayer(previewLayer)
        previewLayer?.frame = video.layer.frame
        
        captureSession!.startRunning()
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
    
    private func animateFlashIn() {
        //        flashImage?.hidden = false
        //        UIView.animateWithDuration(0.15, animations: { () -> Void in
        //            self.flashImage?.alpha = 1.0
        //            }) { (done) -> Void in
        //                self.animateFlashOut()
        //        }
    }
    
    private func animateFlashOut() {
        //        UIView.animateWithDuration(0.1, animations: { () -> Void in
        //            self.flashImage?.alpha = 0.0
        //            }) { (done) -> Void in
        //                self.flashImage?.hidden = true
        //        }
    }
    
    private func startRecording() {
        println("start recording")
        //        SocialMediaManager(parentVC: self).openShareDialog()
        captureSession!.startRecording()
        
        animateFlashIn()
    }
    
    private func stopRecording() {
        println("stop recording")
        captureSession!.stopRecording()
        animateFlashIn()
        doneModal?.hidden = false
    }
}