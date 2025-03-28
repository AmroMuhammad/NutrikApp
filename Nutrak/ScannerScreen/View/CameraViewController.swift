//
//  CameraViewController.swift
//  Nutrak
//
//  Created by Amr Muhammad on 29/03/2025.
//

import UIKit
import AVFoundation

protocol CameraViewControllerDelegate: AnyObject {
    func didCaptureImage(_ image: UIImage)
}

class CameraViewController: UIViewController {

    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var photoOutput: AVCapturePhotoOutput?
    weak var delegate: CameraViewControllerDelegate?
    var captureRect: CGRect = .zero {
        didSet {
            print("Capture rect updated in VC: \(captureRect)")
        }
    }
    var previewSize: CGSize = .zero
    let config = CameraConfiguration.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePreviewLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if previewSize == .zero {
            updatePreviewSize()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.global(qos: .background).async {[weak self] in
            guard let self else { return }
            self.captureSession?.stopRunning()
        }
    }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = config.sessionPreset
        
        guard let backCamera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: backCamera) else {
            print("Unable to access back camera!")
            return
        }
        guard let captureSession else { return }
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        photoOutput = AVCapturePhotoOutput()
        guard let photoOutput else { return }
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        setupPreviewLayer()
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self else { return }
            self.captureSession?.startRunning()
        }
    }
    
    private func setupPreviewLayer() {
        guard let captureSession else { return }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = config.videoGravity
        guard let previewLayer else { return }
        view.layer.addSublayer(previewLayer)
    }
    
    private func updatePreviewLayer() {
        guard let previewLayer = previewLayer else { return }
        previewLayer.frame = view.bounds
        updatePreviewSize()
    }
    
    private func updatePreviewSize() {
        guard let previewLayer else { return }
        previewSize = previewLayer.bounds.size
        print("Preview size updated: \(previewSize)")
    }
    
    func capturePhoto() {
        if previewSize == .zero {
            updatePreviewSize()
        }
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              var image = UIImage(data: imageData) else {
            print("Failed to get image data from photo")
            return
        }
        
        image = normalizedImage(image)
        let croppedImage = cropImage(image, to: captureRect)
        delegate?.didCaptureImage(croppedImage)
    }
    
    private func normalizedImage(_ image: UIImage) -> UIImage {
        guard image.imageOrientation != .up else { return image }
        
        let renderer = UIGraphicsImageRenderer(size: image.size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: image.size))
        }
    }
    
    private func cropImage(_ image: UIImage, to rect: CGRect) -> UIImage {
        print("Captured image size: \(image.size)")
        print("Using preview size: \(previewSize)")
        print("Capture rect: \(rect)")
        
        guard previewSize.width > 0, previewSize.height > 0 else {
            print("Invalid preview size: \(previewSize)")
            return image
        }
        
        let imageSize = image.size
        var scaleX = imageSize.width / previewSize.width
        var scaleY = imageSize.height / previewSize.height
        
        // Adjust scaling based on device orientation
        let deviceOrientation = UIDevice.current.orientation
        if deviceOrientation.isLandscape {
            scaleX = imageSize.width / previewSize.height
            scaleY = imageSize.height / previewSize.width
        }
        
        var scaledRect = CGRect(
            x: rect.origin.x * scaleX,
            y: rect.origin.y * scaleY,
            width: rect.width * scaleX,
            height: rect.height * scaleY
        )
        
        scaledRect = adjustRectForOrientation(scaledRect, imageSize: imageSize, orientation: deviceOrientation)
        
        scaledRect.origin.x = max(0, scaledRect.origin.x)
        scaledRect.origin.y = max(0, scaledRect.origin.y)
        scaledRect.size.width = min(imageSize.width - scaledRect.origin.x, scaledRect.width)
        scaledRect.size.height = min(imageSize.height - scaledRect.origin.y, scaledRect.height)
        
        print("Scaled rect: \(scaledRect)")
        
        guard scaledRect.width > 0, scaledRect.height > 0,
              let cgImage = image.cgImage?.cropping(to: scaledRect) else {
            print("Failed to crop image")
            return image
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    private func adjustRectForOrientation(_ rect: CGRect, imageSize: CGSize, orientation: UIDeviceOrientation) -> CGRect {
        switch orientation {
        case .landscapeLeft:
            return CGRect(
                x: rect.origin.y,
                y: imageSize.height - rect.origin.x - rect.width,
                width: rect.height,
                height: rect.width
            )
        case .landscapeRight:
            return CGRect(
                x: imageSize.width - rect.origin.y - rect.height,
                y: rect.origin.x,
                width: rect.height,
                height: rect.width
            )
        default:
            return rect
        }
    }
}
