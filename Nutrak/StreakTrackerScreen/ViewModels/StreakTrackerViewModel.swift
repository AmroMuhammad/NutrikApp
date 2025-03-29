//
//  StreakTrackerViewModel.swift
//  Nutrak
//
//  Created by Amr Muhammad on 29/03/2025.
//

import Foundation

class StreakTrackerViewModel: ObservableObject {
    @Published var currentStreak: Int
    @Published var streakDays: [Date]
    @Published var milestones: [Milestone]
    
    let currentDate: Date
    
    init(currentDate: Date = Date()) {
        self.currentDate = currentDate
        self.currentStreak = 5
        
        let calendar = Calendar.current
        self.streakDays = (0..<5).reversed().map { offset in
            calendar.date(byAdding: .day, value: -offset, to: currentDate)!
        }
        
        self.milestones = mileStoneMockData
    }
    
    func markDayComplete() {
        if !streakDays.contains(where: { Calendar.current.isDate($0, inSameDayAs: currentDate) }) {
            streakDays.append(currentDate)
            currentStreak += 1
            checkMilestones()
        }
    }
    
    private func checkMilestones() {
        for index in milestones.indices {
            if !milestones[index].achieved && currentStreak >= milestones[index].days {
                milestones[index].achieved = true
            }
        }
    }
    
    func getNextMilestone() -> Milestone? {
        milestones.first { !$0.achieved }
    }
    
    func getAchievedMilestones() -> [Milestone] {
        milestones.filter { $0.achieved }
    }
}
