//
//  NutritionData.swift
//  Nutrak
//
//  Created by Amr Muhammad on 29/03/2025.
//

import SwiftUI

struct NutritionData: Identifiable {
    let id = UUID()
    let day: String
    let value: Double
}

struct NutrientInfo {
    let name: String
    let value: String
    let icon: String
}

struct NutritionAnalysis {
    let image: UIImage
    let foodName: String
    let calories: NutrientInfo
    let macronutrients: [NutrientInfo]
    let micronutrients: [NutrientInfo]
    let weeklyData: [NutritionData]
}


func getMockData(image: UIImage, foodName: String) -> NutritionAnalysis {
    NutritionAnalysis(
        image: image,
        foodName: foodName,
        calories: NutrientInfo(name: "Calories", value: "320 kcal", icon: "Calories"),
        macronutrients: [
            NutrientInfo(name: "Proteins", value: "20g", icon: "Proteins"),
            NutrientInfo(name: "Carbs", value: "40g", icon: "Carbs"),
            NutrientInfo(name: "Fats", value: "10g", icon: "Fats")
        ],
        micronutrients: [
            NutrientInfo(name: "Vitamin A", value: "10%", icon: "Vitamin A"),
            NutrientInfo(name: "Calcium", value: "15%", icon: "Calcium")
        ],
        weeklyData: [
            NutritionData(day: "S", value: 10),
            NutritionData(day: "M", value: 20),
            NutritionData(day: "T", value: 50),
            NutritionData(day: "W", value: 30),
            NutritionData(day: "T", value: 40),
            NutritionData(day: "F", value: 15),
            NutritionData(day: "S", value: 25)
        ]
    )
}
