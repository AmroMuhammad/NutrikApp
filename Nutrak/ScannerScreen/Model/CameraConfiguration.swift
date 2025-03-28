//
//  CameraConfiguration.swift
//  Nutrak
//
//  Created by Amr Muhammad on 29/03/2025.
//

import Foundation
import AVFoundation

struct CameraConfiguration {
    let sessionPreset: AVCaptureSession.Preset
    let videoGravity: AVLayerVideoGravity
    let cornerLength: CGFloat
    let borderWidth: CGFloat
    
    static let `default` = CameraConfiguration(
        sessionPreset: .photo,
        videoGravity: .resizeAspectFill,
        cornerLength: 30,
        borderWidth: 2
    )
}
