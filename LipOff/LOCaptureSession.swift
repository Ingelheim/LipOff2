import UIKit
import AVFoundation
import AssetsLibrary


class TGTMCaptureSession : AVCaptureSession, AVCaptureFileOutputRecordingDelegate {
    var captureVideoDevice : AVCaptureDevice?
    var captureAudioDevice : AVCaptureDevice?
    var movieDataOutput : AVCaptureMovieFileOutput?
    var parent : UIViewController?
    
    var imageLayer : CALayer?
    var videoLayer : CALayer?
    var parentLayer : CALayer?
    
    override init() {
        super.init()
        setGeneralSettings()
        setInputSettings()
        setOutputSettings()
        
        if bothDevicesSet() {
            beginPreviewSession()
        }
    }
    
    func startRecording() {
        self.addOutput(movieDataOutput!)
        self.startRunning()
    }
    
    func stopRecording() {
        println("STOPP")
        stopRunning()
        movieDataOutput!.stopRecording()
        movieDataOutput!.startRecordingToOutputFileURL(NSURL(fileURLWithPath: "\(NSTemporaryDirectory())test.MOV"), recordingDelegate: self)
    }
    
    private func setGeneralSettings() {
        self.sessionPreset = AVCaptureSessionPresetMedium
    }
    
    private func setInputSettings() {
        let devices = AVCaptureDevice.devices()
        
        for device in devices {
            if (isVideo(device)) {
                if(isFrontCamera(device)) {
                    setCamera(device)
                }
            }
        }
        
        if let audioDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio) {
            setMicrophone(audioDevice)
        }
    }
    
    private func setOutputSettings() {
        movieDataOutput = AVCaptureMovieFileOutput()
    }
    
    private func isVideo(device: AnyObject) -> Bool {
        return device.hasMediaType(AVMediaTypeVideo)
    }
    
    private func isFrontCamera(device: AnyObject) -> Bool {
        return device.position == AVCaptureDevicePosition.Front
    }
    
    private func setCamera(device: AnyObject) {
        captureVideoDevice = device as? AVCaptureDevice
    }
    
    private func setMicrophone(device: AnyObject) {
        captureAudioDevice = device as? AVCaptureDevice
    }
    
    private func bothDevicesSet() -> Bool {
        return captureAudioDevice != nil && captureVideoDevice != nil
    }
    
    private func addCamera() {
        var err : NSError? = nil
        self.addInput(AVCaptureDeviceInput(device: captureVideoDevice!, error: &err))
    }
    
    private func addMicrophone() {
        var err : NSError? = nil
        self.addInput(AVCaptureDeviceInput(device: captureAudioDevice!, error: &err))
    }
    
    private func beginPreviewSession() {
        addCamera()
        addMicrophone()
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        
        println("DONE")
        
        let pathString = outputFileURL.relativePath
        var asset = AVAsset.assetWithURL(outputFileURL) as! AVAsset
        var composition = AVMutableVideoComposition(propertiesOfAsset: asset)
        composition.renderSize = CGSizeMake(parent!.view.frame.width, parent!.view.frame.height)
        
        imageLayer =  createOverlayLayer(740, heigth: 1334)
        parentLayer = createParentLayer(740, heigth: 1334)
        videoLayer = createParentLayer(740, heigth: 1334)
        
        parentLayer?.addSublayer(videoLayer)
        parentLayer?.addSublayer(imageLayer)
        
        composition.renderScale = 1.0
        
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, inLayer: parentLayer)
        
        var assetExport = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality as String)
        assetExport.videoComposition = composition
        assetExport.outputFileType = AVFileTypeMPEG4
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        assetExport.outputURL = NSURL(fileURLWithPath: "\(NSTemporaryDirectory())\(date)\(hour)\(minutes)\(arc4random()).MOV")
        
        assetExport.exportAsynchronouslyWithCompletionHandler({() -> Void in
            println("done \(assetExport.outputURL)")
            //            when saved share it
            
            
            //            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
            //            [assetLibrary writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error){
            
            var assetLibrary = ALAssetsLibrary()
            //            assetLibrary.writeVideoAtPathToSavedPhotosAlbum(assetExport.outputURL, completionBlock: {
            //                println("savedddd")
            //            })
            
            assetLibrary.writeVideoAtPathToSavedPhotosAlbum(assetExport.outputURL, completionBlock: { (url, error) -> Void in
                println("savedddd \(url) and error \(error)")
            })
            
            //            UISaveVideoAtPathToSavedPhotosAlbum(assetExport.outputURL.relativePath, self, nil, nil)
            //            SocialMediaManager(parentVC: self.parent!).openShareDialog(assetExport.outputURL)
        })
    }
    
    private func createOverlayLayer(width: CGFloat, heigth: CGFloat) -> CALayer {
        var layer = CALayer()
        var image = UIImage(named: "Ryan")
        
        layer.frame = CGRect(x: 0, y: 0, width: parent!.view.frame.width, height: parent!.view.frame.height)
        layer.contents = image?.CGImage
        return layer
    }
    
    private func createParentLayer(width: CGFloat, heigth: CGFloat) -> CALayer {
        var layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: parent!.view.frame.width, height: parent!.view.frame.height)
        return layer
    }
    
    private func startCapturing() {
        self.addOutput(movieDataOutput!)
        self.startRunning()
    }
}