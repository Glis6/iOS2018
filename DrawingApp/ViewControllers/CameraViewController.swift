//
//  CameraViewController.swift
//  DrawingApp
//
//  Created by Gilles Vercammen on 1/4/18.
//  Copyright © 2018 Gilles Vercammen. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    //The view that displays the camera, or a black screen if no camera available.
    @IBOutlet
    weak var cameraView: UIView!
    
    //The view that holds the drawing.
    @IBOutlet
    weak var imageView: UIImageView!
    
    //The drawing that we're using as overlay.
    var drawing: Drawing?
    
    //The layer that holds the video preview.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    //The output to use when we take a picture.
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    var session: AVCaptureSession?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = drawing?.image
        session = AVCaptureSession()
        session?.sessionPreset = AVCaptureSession.Preset.photo
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        
        var error: NSError? = nil
        var input: AVCaptureDeviceInput!
        if backCamera != nil {
            do {
                input = try AVCaptureDeviceInput(device: backCamera!)
            } catch let thrownError as NSError {
                error = thrownError
                input = nil
                print(error!.localizedDescription)
            }
            if error == nil && (session?.canAddInput(input))! {
                session?.addInput(input)
            }
        }
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraView.layer.addSublayer(videoPreviewLayer!)
        imageView.image = imageView.image!.changeWhiteColorTransparent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer!.frame = cameraView.bounds
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        
        session?.addOutput(capturePhotoOutput!)
        session?.startRunning()
    }
}
