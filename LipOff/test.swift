import UIKit
import AVFoundation
import Foundation
import QuartzCore

class CameraRecordController: TGTMViewController , AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate{
    var captureSession : AVCaptureSession?
    var captureVideoDevice : AVCaptureDevice?
    var captureAudioDevice : AVCaptureDevice?
    var output: AVCaptureMovieFileOutput?
    var imageLayer : CALayer?
    var videoLayer : CALayer?
    var parentLayer : CALayer?
    var playing = false
    var button : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetSession()
    }
    
    private func resetSession() {
        captureSession = AVCaptureSession()
        output = AVCaptureMovieFileOutput()
        captureSession!.sessionPreset = AVCaptureSessionPresetHigh
        setUpCaptureDeviceVideo()
        startCapturing()
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
        println("DONE")
        
        let pathString = outputFileURL.relativePath
        //        UISaveVideoAtPathToSavedPhotosAlbum(pathString, self, nil, nil)
        
        var asset = AVAsset.assetWithURL(outputFileURL) as! AVAsset
        
        var composition = AVMutableVideoComposition(propertiesOfAsset: asset)
        
        println(asset.metadata)
        
        var height = composition.renderSize.height
        var width = composition.renderSize.height
        
        imageLayer =  createOverlayLayer(740, heigth: 1334)
        parentLayer = createParentLayer(740, heigth: 1334)
        videoLayer = createParentLayer(740, heigth: 1334)
        
        parentLayer?.addSublayer(videoLayer)
        parentLayer?.addSublayer(imageLayer)
        
        composition.renderScale = 1.0
        
        videoLayer?.addSublayer(test(740, heigth: 1334))
        
        println(parentLayer?.sublayers)
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, inLayer: parentLayer)
        
        println(composition)
        
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
            println("done")
            UISaveVideoAtPathToSavedPhotosAlbum(assetExport.outputURL.relativePath, self, nil, nil)
        })
    }
    
    private func startCapturing() {
        var err : NSError? = nil
        
        if let recordingVideoDevice = captureVideoDevice {
            captureSession!.addInput(AVCaptureDeviceInput(device: recordingVideoDevice, error: &err))
        }
        
        if let recordingAudioDevice = captureAudioDevice {
            captureSession!.addInput(AVCaptureDeviceInput(device: recordingAudioDevice, error: &err))
        }
        
        captureSession!.addOutput(output)
        
        var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.addSublayer(test(740, heigth: 1334))
        
        self.view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.layer.frame
        
        self.view.layer.addSublayer(createOverlayLayerForView())
        
        button = UIButton(frame: CGRect(x: (self.view.frame.midX - 25), y: (self.view.frame.maxY - 60), width: 50, height: 50))
        button!.backgroundColor = UIColor.blueColor()
        button!.addTarget(self, action: Selector("done"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button!)
        captureSession!.startRunning()
        
    }
    
    func done () {
        if (!playing) {
            button!.backgroundColor = UIColor.redColor()
            output!.startRecordingToOutputFileURL(NSURL(fileURLWithPath: "\(NSTemporaryDirectory())test.MOV"), recordingDelegate: self)
            playing = true
        } else {
            button!.backgroundColor = UIColor.blueColor()
            captureSession!.stopRunning()
            output!.stopRecording()
            resetSession()
            playing = false
        }
    }
    
    private func createBackgroundLayer() -> UIImageView  {
        var image = UIImageView(image: UIImage(named: "KanyeCroppedAlpha"))
        image.frame = self.view.frame
        image.contentMode = UIViewContentMode.ScaleAspectFill
        
        return image
    }
    
    private func createOverlayLayer(width: CGFloat, heigth: CGFloat) -> CALayer {
        var layer = CALayer()
        var image = UIImage(named: "KanyeCroppedAlpha")
        
        layer.frame = CGRectMake(0, 0, width, heigth)
        layer.contents = image?.CGImage
        return layer
    }
    
    private func createOverlayLayerForView() -> CALayer {
        var layer = CALayer()
        var image = UIImage(named: "KanyeCroppedAlpha")
        layer.frame = self.view.frame
        layer.contents = image?.CGImage
        return layer
    }
    
    private func createParentLayer(width: CGFloat, heigth: CGFloat) -> CALayer {
        var layer = CALayer()
        //        layer.frame = self.view.frame
        layer.frame = CGRectMake(0, 0, width, heigth)
        //        layer.frame = self.view.frame
        return layer
    }
    
    private func test(width: CGFloat, heigth: CGFloat) -> CALayer {
        var layer = CALayer()
        //        layer.frame = self.view.frame
        layer.frame = CGRectMake(0, 0, width, heigth)
        //        var copiedColour =
        //        CGColorCreateCopyWithAlpha
        layer.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.1/5).CGColor
        //        layer.frame = self.view.frame
        return layer
    }
    
    private func createVideoLayer(width: CGFloat, heigth: CGFloat) -> CALayer {
        var layer = CALayer()
        //        layer.frame = self.view.frame
        //        layer.frame = self.view.frame
        layer.frame = CGRectMake(0, 0, width, heigth);
        return layer
    }
}