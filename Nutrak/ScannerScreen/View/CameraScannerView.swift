//
//  CameraScannerView.swift
//  Nutrak
//
//  Created by Amr Muhammad on 29/03/2025.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct CameraScannerView: View {
    @StateObject private var viewModel = CameraScannerViewModel()
    private let config = CameraConfiguration.default
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    CameraView(
                        capturedImage: $viewModel.capturedImage,
                        captureRect: viewModel.captureRect,
                        onControllerCreated: viewModel.onCameraControllerCreated
                    )
                    
                    overlayViews
                    
                    if viewModel.showProgressView {
                        ProgressIndicatorView(
                            onCompletion: {
                                viewModel.onScanCompleted()
                            },
                            onCancel: {
                                viewModel.dismissPreview()
                            }
                        )
                        .transition(.opacity)
                        .zIndex(1)
                    }
                    
                    controlsView
                }
                .onChange(of: geometry.size, initial: true) { oldValue, newValue in
                    viewModel.setupCaptureRect(geometry: geometry)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var overlayViews: some View {
        Group {
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .mask(
                    Rectangle()
                        .fill(Color.black)
                        .overlay(
                            Rectangle()
                                .frame(width: viewModel.captureRect.width, height: viewModel.captureRect.height)
                                .position(x: viewModel.captureRect.midX, y: viewModel.captureRect.midY)
                                .blendMode(.destinationOut)
                        )
                )
            
            Path { path in
                let cornerPath = CaptureRect(
                    frame: viewModel.captureRect,
                    cornerLength: config.cornerLength,
                    borderWidth: config.borderWidth,
                    cornerRadius: 40
                ).cornerPath(in: viewModel.captureRect)
                path.addPath(cornerPath)
            }
            .stroke(Color.green, style: StrokeStyle(lineWidth: config.borderWidth, lineJoin: .round))
        }
    }
    
    private var controlsView: some View {
        VStack {
            instructionView
            Spacer()
            buttonsView
        }
    }
    
    private var instructionView: some View {
        HStack {
            Image(systemName: "camera.viewfinder")
                .foregroundColor(Color(.nutrikWhite))
            VStack(alignment: .leading, spacing: 5) {
                Text("Scan Your Food")
                    .foregroundColor(Color(.nutrikWhite))
                    .font(.system(size: 12, weight: .bold))
                Text("Ensure your food is well-lit and in focus for the most accurate scan.")
                    .foregroundColor(Color(.nutrikWhite))
                    .font(.system(size: 10))
            }
            Spacer()
        }
        .padding()
        .background(Color(.nutrikBlack).opacity(0.7))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 50)
    }
    
    private var buttonsView: some View {
        HStack {
            PhotosPicker(selection: $viewModel.photoPickerItem, matching: .images) {
                Image(systemName: "photo.on.rectangle")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            if !viewModel.showProgressView {
                Button(action: viewModel.capturePhoto) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(Color.green, lineWidth: 3)
                        )
                }
            }
            
            Spacer()
            
            Circle()
                .fill(Color.clear)
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 30)
    }
}

#Preview {
    CameraScannerView()
}
