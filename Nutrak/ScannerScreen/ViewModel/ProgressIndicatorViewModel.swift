//
//  ProgressIndicatorViewModel.swift
//  Nutrak
//
//  Created by Amr Muhammad on 29/03/2025.
//

import Foundation
import Combine
import SwiftUI

class ProgressIndicatorViewModel: ObservableObject {

    @Published var progress: Double = 0.0
    @Published var isLoading: Bool = false
    @Published var statusMessage: String = "Scanning in progress..."
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    let activeColor = Color.green.opacity(0.7)
    let inactiveColor = Color.gray.opacity(0.2)
    
    func startLoadingSimulation(duration: TimeInterval = 5.0) {
        guard !isLoading else { return }
        
        isLoading = true
        progress = 0.0
        statusMessage = "Scanning in progress..."
        
        let incrementInterval = 0.05
        let increments = duration / incrementInterval
        let progressIncrement = 1.0 / increments
        
        timer = Timer.scheduledTimer(withTimeInterval: incrementInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.progress >= 1.0 {
                self.completeLoading()
            } else {
                self.progress += progressIncrement
            }
        }
    }
    
    func completeLoading() {
        timer?.invalidate()
        timer = nil
        isLoading = false
        statusMessage = "Scan complete!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.progress = 0.0
            self?.statusMessage = "Scanning in progress..."
        }
    }
    
    func cancelLoading() {
        timer?.invalidate()
        timer = nil
        isLoading = false
        progress = 0.0
        statusMessage = "Scan cancelled"
    }
    
    func getSegmentColor(index: Int, totalSegments: Int = 36) -> Color {
        let progressIndex = Int(progress * Double(totalSegments))
        return index < progressIndex ? activeColor : inactiveColor
    }
}
