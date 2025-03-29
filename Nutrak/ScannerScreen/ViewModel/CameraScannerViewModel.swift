//
//  CameraScannerViewModel.swift
//  Nutrak
//
//  Created by Amr Muhammad on 29/03/2025.
//

import SwiftUI
import Combine
import PhotosUI

class CameraScannerViewModel: ObservableObject {
    
    @Published var capturedImage: UIImage?
    @Published var photoPickerItem: PhotosPickerItem?
    @Published var captureRect: CGRect = .zero
    @Published var showProgressView = false
    
    private var cancellables = Set<AnyCancellable>()
    private weak var cameraController: CameraViewController?
    
    var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    // MARK: - Initialization
    init() {
        setupBindings()
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        $photoPickerItem
            .compactMap { $0 }
            .flatMap { item in
                Future<UIImage?, Never> { promise in
                    Task {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            promise(.success(image))
                        } else {
                            promise(.success(nil))
                        }
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.capturedImage = image
                self?.showProgressView = image != nil
            }
            .store(in: &cancellables)
        
        $capturedImage
            .map { $0 != nil }
            .assign(to: &$showProgressView)
    }
    
    // MARK: - Public Methods
    func setupCaptureRect(geometry: GeometryProxy) {
        let squareSize = min(geometry.size.width, geometry.size.height) * 0.7
        let rectX = (geometry.size.width - squareSize) / 2
        let rectY = (geometry.size.height - squareSize) / 2
        captureRect = CGRect(x: rectX, y: rectY, width: squareSize, height: squareSize)
    }
    
    func onCameraControllerCreated(_ controller: CameraViewController) {
        cameraController = controller
        controller.captureRect = captureRect
    }
    
    func capturePhoto() {
        if isSimulator {
            capturedImage = UIImage(named: "pepperoni_pizza")
        } else {
            cameraController?.capturePhoto()
        }
    }
    
    func dismissPreview() {
        capturedImage = nil
        showProgressView = false
    }
    
    func onScanCompleted() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showProgressView = false
        }
    }
}
