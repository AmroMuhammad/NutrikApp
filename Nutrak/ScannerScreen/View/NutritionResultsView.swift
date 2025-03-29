//
//  NutritionResultsView.swift
//  Nutrak
//
//  Created by Amr Muhammad on 29/03/2025.
//

import SwiftUI
import Charts

struct NutritionResultsView: View {
    @StateObject var viewModel: NutritionResultsViewModel
    @Environment(\.presentationMode) var presentationMode
        
    var body: some View {
            ScrollView {
                VStack(spacing: 0) {
                    // Header Image
                    headerImage.ignoresSafeArea(edges: .top)
                    
                    // Content Sections
                    VStack(alignment: .leading, spacing: 20) {
                        nutritionalOverview
                        macronutrientsSection
                        micronutrientsSection
                        weeklyNutritionChart
                        actionButtons
                    }
                    .padding(.vertical)
                }
            }
            .ignoresSafeArea(edges: .top)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Nutrition Results")
                        .font(.headline)
                        .foregroundColor(Color(.nutrikBlack))
                }
            }
    }
    
    // MARK: - Subviews
    
    private var headerImage: some View {
        ZStack(alignment: .bottom) {
            Image(uiImage: viewModel.analysis.image)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()
            
            HStack {
                Text(viewModel.analysis.foodName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.bottom, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, Color.black.opacity(0.6)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                )
            }
        }
        .frame(height: 200)
    }
    
    private var nutritionalOverview: some View {
        nutrientGridSection(
            title: "Nutritional Overview:",
            subtitle: "",
            nutrients: [viewModel.analysis.calories]
        )
    }
    
    private var macronutrientsSection: some View {
        nutrientGridSection(
            title: "Macronutrients",
            subtitle: "Total: 60g",
            nutrients: viewModel.analysis.macronutrients
        )
    }
    
    private var micronutrientsSection: some View {
        nutrientGridSection(
            title: "Micronutrients",
            subtitle: "Total: 30%",
            nutrients: viewModel.analysis.micronutrients
        )
    }
    
    private func nutrientGridSection(title: String, subtitle: String, nutrients: [NutrientInfo]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(.nutrikBlack))
                    .padding(.horizontal)
                
                Spacer()
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.nutrikGray))
                    .padding(.horizontal)

            }
            let columns = [GridItem(.flexible(), spacing: 12),
                          GridItem(.flexible(), spacing: 12)]
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(nutrients, id: \.name) { nutrient in
                    NutrientCard(nutrient: nutrient)
                        .frame(height: 80)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var weeklyNutritionChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Weekly Meal Nutrition")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(.nutrikGray))
                .padding(.horizontal)
            
            Chart(viewModel.analysis.weeklyData) { item in
                BarMark(
                    x: .value("Day", item.day),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(Color(.nutrikOrange))
                .cornerRadius(4)
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisValueLabel()
                        .foregroundStyle(Color(.nutrikGray))
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisValueLabel()
                        .foregroundStyle(Color(.nutrikGray))
                }
            }
            .frame(height: 150)
            .padding()
            .background(Color(.nutrikWhite))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: viewModel.saveToDailyLog) {
                Text("Save to Daily Log")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.nutrikOrange))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            HStack(spacing: 4) {
                Text("Want more insights?")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.nutrikGray))

                Button("Upgrade to Premium") {
                    viewModel.upgradeToPremium()
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(.nutrikOrange))
            }
        }
        .padding(.bottom, 70)
    }
}

// MARK: - Preview

#Preview {
    NutritionResultsView(viewModel: NutritionResultsViewModel(image: UIImage(named: "pepperoni_pizza") ?? UIImage(), foodName: "Pepperoni Pizza"))
}
