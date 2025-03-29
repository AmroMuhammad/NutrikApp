//
//  Milestone.swift
//  Nutrak
//
//  Created by Amr Muhammad on 29/03/2025.
//

import SwiftUI

struct Milestone: Identifiable {
    let id = UUID()
    let days: Int
    let title: String
    var achieved: Bool
    
    var color: Color {
        switch days {
        case 7: return .gray
        case 10: return .orange
        case 20: return .blue
        case 30: return .purple
        case 50: return .green
        case 100: return .red
        default: return .gray
        }
    }
    
    var icon: String {
        switch days {
        case 7: return "trophy"
        case 10: return "trophy.fill"
        case 20: return "rosette"
        case 30: return "medal"
        case 50: return "crown"
        case 100: return "star.circle.fill"
        default: return "trophy"
        }
    }
}

let mileStoneMockData = [
    Milestone(days: 7, title: "7-day streak achiever", achieved: true),
    Milestone(days: 10, title: "10-day streak achiever", achieved: false),
    Milestone(days: 20, title: "20-day streak achiever", achieved: false),
    Milestone(days: 30, title: "30-day streak achiever", achieved: false),
    Milestone(days: 50, title: "50-day streak master", achieved: false),
    Milestone(days: 100, title: "100-day streak legend", achieved: false)
]
