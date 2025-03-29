//
//  ProgressIndicatorView.swift
//  Nutrak
//
//  Created by Amr Muhammad on 29/03/2025.
//

import SwiftUI

struct ProgressIndicatorView: View {
    @StateObject var viewModel = ProgressIndicatorViewModel()
    let logoText: String
    let onCompletion: (() -> Void)?
    let onCancel: (() -> Void)?
    
    init(logoText: String = "nutrak", onCompletion: (() -> Void)? = nil, onCancel: (() -> Void)? = nil) {
        self.logoText = logoText
        self.onCompletion = onCompletion
        self.onCancel = onCancel
    }
    
    var body: some View {
        VStack {
            Text(logoText)
                .font(.title)
                .foregroundColor(.orange)
                .padding(.top, 20)
            
            Spacer()
            
            segmentedLoader
            
            progressStatusView
            
            Spacer()
            
            if viewModel.isLoading {
                Button(action: {
                    viewModel.cancelLoading()
                    onCancel?()
                }) {
                    Text("Cancel")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            viewModel.startLoadingSimulation()
        }
        .onChange(of: viewModel.isLoading, initial: true) {
            if !viewModel.isLoading && viewModel.progress >= 1.0 {
                onCompletion?()
            }
        }
        .background(Color(.nutrikWhite))
    }
        
    private var segmentedLoader: some View {
        ZStack {
            ForEach(0..<36) { i in
                Circle()
                    .trim(from: 0.0, to: 0.025)
                    .stroke(viewModel.getSegmentColor(index: i), lineWidth: 8)
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(Double(i) * 10))
            }
        }
        .padding(.bottom, 20)
    }
    
    private var progressStatusView: some View {
        VStack(spacing: 8) {
            Text(viewModel.statusMessage)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(viewModel.inactiveColor)
                        .frame(width: geometry.size.width, height: 4)
                    
                    Rectangle()
                        .fill(viewModel.activeColor)
                        .frame(width: geometry.size.width * viewModel.progress, height: 4)
                }
            }
            .frame(height: 4)
            .padding(.horizontal, 40)
            
            Text("\(Int(viewModel.progress * 100))%")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    ProgressIndicatorView()
}
