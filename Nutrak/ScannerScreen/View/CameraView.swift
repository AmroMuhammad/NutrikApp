//
//  CameraView.swift
//  Nutrak
//
//  Created by Amr Muhammad on 29/03/2025.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    let captureRect: CGRect
    let onControllerCreated: (CameraViewController) -> Void
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.delegate = context.coordinator
        controller.captureRect = captureRect
        onControllerCreated(controller)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        uiViewController.captureRect = captureRect
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CameraViewControllerDelegate {
        var parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func didCaptureImage(_ image: UIImage) {
            parent.capturedImage = image
        }
    }
}

#Preview {
    CameraView(capturedImage: Binding.constant(UIImage(named: "pepronni-pizza")), captureRect: .zero, onControllerCreated: { _ in })
}
