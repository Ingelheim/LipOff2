import UIKit
import AVFoundation
import MediaPlayer

class VideoManager: NSObject, AVCaptureFileOutputRecordingDelegate {
    var captureSession = AVCaptureSession()
    var captureVideoDevice : AVCaptureDevice?
    var captureAudioDevice : AVCaptureDevice?
    var output = AVCaptureMovieFileOutput()
    var imageLayer : CALayer?
    var videoLayer : CALayer?
    var parentLayer : CALayer?
    var playing = false
    var button : UIButton?
    var savedCallback : ((url: NSURL) -> Void)?
    var selectedTile : TILE_POSITION?

    func setup() {
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        setUpCaptureDeviceVideo()
    }
    
    private func setUpCaptureDeviceVideo() {
        let devices = AVCaptureDevice.devices()
        
        for device in devices {
            
            if (device.hasMediaType(AVMediaTypeVideo)) {
                setVideoDevice(device as! AVCaptureDevice)
            } else if (device.hasMediaType(AVMediaTypeAudio)){
                setAudioDevice(device as! AVCaptureDevice)
            }
        }
    }
    
    private func setVideoDevice(device: AVCaptureDevice) {
        if(device.position == AVCaptureDevicePosition.Front) {
            captureVideoDevice = device
        }
    }
    
    private func setAudioDevice(device: AVCaptureDevice) {
        captureAudioDevice = device
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        
        let pathString = outputFileURL.relativePath
        var asset = AVAsset.assetWithURL(outputFileURL) as! AVAsset
        var composition = AVMutableVideoComposition(propertiesOfAsset: asset)
        
        println(UIScreen.mainScreen().bounds)
        var screenWidth = UIScreen.mainScreen().bounds.width
        var screenHeight = UIScreen.mainScreen().bounds.height
        var screenRatio = screenHeight / screenWidth
        
        println("RATIO \(screenRatio)")
        
        var width : CGFloat = 720
        var height : CGFloat = 1280
        var isSmall = false
        
        if ( screenRatio <= 1.60) {
            width = 480
            height = 720
            isSmall = true
        }
        
        imageLayer =  createOverlayLayer(width, heigth: height)
        parentLayer = createParentLayer(width, heigth: height)
        videoLayer = createParentLayer(width, heigth: height)
        
        parentLayer?.addSublayer(videoLayer)
        parentLayer?.addSublayer(imageLayer)
        parentLayer?.addSublayer(createWebViewLayer(width, heigth: height, small: isSmall))
        
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
        let seconds = components.second
        assetExport.outputURL = NSURL(fileURLWithPath: "\(NSTemporaryDirectory())LipOffMovie_\(date)\(hour)\(minutes)\(seconds).MOV")
        
        assetExport.exportAsynchronouslyWithCompletionHandler({() -> Void in
            UISaveVideoAtPathToSavedPhotosAlbum(assetExport.outputURL.relativePath, self, nil, nil)
            dispatch_async(dispatch_get_main_queue()) {
                self.savedCallback!(url: assetExport.outputURL)
            }
        })
    }
    
    func startCapturing() {
        var err : NSError? = nil
        
        if let recordingVideoDevice = captureVideoDevice {
            captureSession.addInput(AVCaptureDeviceInput(device: recordingVideoDevice, error: &err))
        }
        
        if let recordingAudioDevice = captureAudioDevice {
            captureSession.addInput(AVCaptureDeviceInput(device: recordingAudioDevice, error: &err))
        }
        
        captureSession.addOutput(output)
        captureSession.startRunning()
    }
    
    func done () {
        if (!playing) {
            output.startRecordingToOutputFileURL(NSURL(fileURLWithPath: "\(NSTemporaryDirectory())temporaryLipOffFile.MOV"), recordingDelegate: self)
            playing = true
        } else {
            captureSession.stopRunning()
            output.stopRecording()
            playing = false
        }
    }
    
    private func createOverlayLayer(width: CGFloat, heigth: CGFloat) -> CALayer {
        var layer = CALayer()
        var image = ImageRepository.sharedRepo.getAlphaFlipImageFor(selectedTile!)
        layer.frame = CGRectMake(0, 0, width, heigth)
        layer.contents = image!.CGImage
        
        return layer
    }
    
    private func createWebViewLayer(width: CGFloat, heigth: CGFloat, small: Bool) -> CALayer {
        var ownWidth : CGFloat = small ? 55.0 : 110.0
        var ownHeight : CGFloat  = small ? 16.5 : 30.0
        var yOffset : CGFloat  = small ? heigth - 150 : heigth - 220
        var xOffset : CGFloat  = 40.0
        
        var layer = CALayer()
        var image = UIImage(named: "Weblink_Plain")
        
        layer.frame = CGRect(x: width - ownWidth - xOffset , y: yOffset, width: ownWidth, height: ownHeight)
        layer.contents = image?.CGImage
        
        return layer
    }
    
    private func createParentLayer(width: CGFloat, heigth: CGFloat) -> CALayer {
        var layer = CALayer()
        layer.frame = CGRectMake(0, 0, width, heigth)
        
        return layer
    }
    
    private func test(width: CGFloat, heigth: CGFloat) -> CALayer {
        var layer = CALayer()
        layer.frame = CGRectMake(0, 0, width, heigth)
        layer.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.1/5).CGColor
        
        return layer
    }
    
    private func createVideoLayer(width: CGFloat, heigth: CGFloat) -> CALayer {
        var layer = CALayer()
        layer.frame = CGRectMake(0, 0, width, heigth)
        
        return layer
    }
}