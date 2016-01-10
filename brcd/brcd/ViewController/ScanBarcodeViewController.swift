//
//  ScanBarcodeViewController.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/01/10.
//  Copyright © 2016 Balsdon. All rights reserved.
//

import UIKit
import AVFoundation

class ScanBarcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blackColor()
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeUPCECode,
                AVMetadataObjectTypeCode39Code,
                AVMetadataObjectTypeCode39Mod43Code,
                AVMetadataObjectTypeEAN13Code,
                AVMetadataObjectTypeEAN8Code,
                AVMetadataObjectTypeCode93Code,
                AVMetadataObjectTypeCode128Code,
                AVMetadataObjectTypePDF417Code,
                AVMetadataObjectTypeQRCode,
                AVMetadataObjectTypeAztecCode,
                AVMetadataObjectTypeInterleaved2of5Code,
                AVMetadataObjectTypeITF14Code,
                AVMetadataObjectTypeDataMatrixCode
            ]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        captureSession.startRunning();
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true) {
            captureSession.stopRunning();
        }
    }
    
    var barcodeCapturedView: UIView? = nil
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue, type: readableObject.type)
            
            let barCodeObject = previewLayer.transformedMetadataObjectForMetadataObject(readableObject) as! AVMetadataMachineReadableCodeObject
            let barcodeCapturedRect = barCodeObject.bounds;
            
            barcodeCapturedView = UIView()
            barcodeCapturedView!.autoresizingMask = [
                UIViewAutoresizing.FlexibleTopMargin,
                UIViewAutoresizing.FlexibleLeftMargin,
                UIViewAutoresizing.FlexibleRightMargin,
                UIViewAutoresizing.FlexibleBottomMargin]
            barcodeCapturedView!.layer.borderColor = UIColor.yellowColor().CGColor
            barcodeCapturedView!.layer.borderWidth = 5;
            barcodeCapturedView!.frame = barcodeCapturedRect;
            view.addSubview(barcodeCapturedView!)
        }
        
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    func foundCode(code: String, type: String) {
        showMessage("Scanned code", message: "Found \(code): \(type)", cancelButtonText: "Ok", onComplete: { action in
            self.barcodeCapturedView?.removeFromSuperview()
            self.captureSession.startRunning()
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
}