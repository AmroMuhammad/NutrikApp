//
//  NutrientCard.swift
//  Nutrak
//
//  Created by Amr Muhammad on 29/03/2025.
//

import SwiftUI

struct NutrientCard: View {
    let nutrient: NutrientInfo
    
    var body: some View {
        HStack(spacing: 12) {
            Image(nutrient.icon)
                .font(.system(size: 20))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(nutrient.name)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.nutrikGray))
                Text(nutrient.value)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(.nutrikBlack))
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color(.nutrikWhite))
        .cornerRadius(10)
        .shadow(color: Color(.nutrikBlack).opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NutrientCard(nutrient: NutrientInfo(name: "Calories", value: "120", icon: "Calories"))
}
