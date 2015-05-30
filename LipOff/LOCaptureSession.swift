import UIKit
import AVFoundation

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
    var savedCallback : (() -> Void)?
    
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
        
        imageLayer =  createOverlayLayer(750, heigth: 1334)
        parentLayer = createParentLayer(750, heigth: 1334)
        videoLayer = createParentLayer(750, heigth: 1334)

        
        parentLayer?.addSublayer(videoLayer)
        parentLayer?.addSublayer(imageLayer)
        parentLayer?.addSublayer(createWebViewLayer(750, heigth: 1334))
        
        composition.renderScale = 1.0
        
        videoLayer?.addSublayer(test(750, heigth: 1334))
        
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
            UISaveVideoAtPathToSavedPhotosAlbum(assetExport.outputURL.relativePath, self, nil, nil)
            self.savedCallback!()
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
            output.startRecordingToOutputFileURL(NSURL(fileURLWithPath: "\(NSTemporaryDirectory())test.MOV"), recordingDelegate: self)
            playing = true
        } else {
            captureSession.stopRunning()
            output.stopRecording()
            playing = false
        }
    }
    
    private func createOverlayLayer(width: CGFloat, heigth: CGFloat) -> CALayer {
        var layer = CALayer()
        var image = UIImage(named: "KanyeCroppedAlphaFlip")
        
        layer.frame = CGRectMake(0, 0, width, heigth)
        layer.contents = image?.CGImage
        return layer
    }
    
    private func createWebViewLayer(width: CGFloat, heigth: CGFloat) -> CALayer {
        var layer = CALayer()
        var image = UIImage(named: "Weblink_Red")
        
        layer.frame = CGRect(x: 30, y: 30, width: 280, height: 85)
        
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
        layer.frame = CGRectMake(0, 0, width, heigth);
        return layer
    }
}