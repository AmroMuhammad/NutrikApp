//
//  NutritionResultsViewModel.swift
//  Nutrak
//
//  Created by Amr Muhammad on 29/03/2025.
//

import SwiftUI

class NutritionResultsViewModel: ObservableObject {
    @Published var analysis: NutritionAnalysis
    
    init(image: UIImage, foodName: String = "Pepperoni Pizza") {
        self.analysis = getMockData(image: image, foodName: foodName)
    }
    
    func saveToDailyLog() {
        print("Saved to daily log")
    }
    
    func upgradeToPremium() {
        print("Upgrade to premium")
    }
}
