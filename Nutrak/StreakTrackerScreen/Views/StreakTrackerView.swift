//
//  StreakTrackerView.swift
//  Nutrak
//
//  Created by Amr Muhammad on 29/03/2025.
//

import SwiftUI
import ConfettiSwiftUI

struct StreakTrackerView: View {
    @StateObject private var viewModel = StreakTrackerViewModel()
    @State private var showingAllMilestones = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    streakHeaderSection
                    
                    calendarSection
                    
                    nextMilestoneSection
                    
                    achievementsSection
                    
                    Button(action: { showingAllMilestones.toggle() }) {
                        Text(showingAllMilestones ? "HIDE MILESTONES" : "VIEW ALL MILESTONES")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.top, 10)
                    
                    if showingAllMilestones {
                        allMilestonesSection
                    }
                    
                    actionButton
                }
                .padding()
            }
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                viewModel.isStreakUpdated = true
            }
        })
        .confettiCannon(
            trigger: $viewModel.confettiCounter,
            num: 50,                     // Number of confetti pieces
            confettiSize: 10,            // Size of each piece
            rainHeight: 1000,            // How far confetti falls
            fadesOut: true,              // Fade out animation
            opacity: 1.0,
            openingAngle: .degrees(60),
            closingAngle: .degrees(120),
            radius: 200
        )
    }
        
    private var streakHeaderSection: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .scaleEffect(viewModel.isStreakUpdated ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: viewModel.isStreakUpdated)
                
                // Flame animation
                Image(systemName: "flame.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.orange)
                    .scaleEffect(viewModel.isStreakUpdated ? 1.5 : 1.0)
                    .animation(
                        .interpolatingSpring(stiffness: 100, damping: 10)
                        .delay(0.1),
                        value: viewModel.isStreakUpdated
                    )
                    .overlay(
                        Text("\(viewModel.currentStreak)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.nutrikBlack))
                            .offset(y: 2)
                            .scaleEffect(viewModel.isStreakUpdated ? 1.2 : 1.0)
                            .animation(
                                .interpolatingSpring(stiffness: 100, damping: 10)
                                .delay(0.2),
                                value: viewModel.isStreakUpdated
                            )
                    )
            }
            .padding(.top, 10)
            .onChange(of: viewModel.currentStreak) { _ in
                viewModel.isStreakUpdated = true
            }
            
            VStack(spacing: 4) {
                Text("Current Streak")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .transition(.opacity)
                
                Text("\(viewModel.currentStreak) days!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .transition(.scale.combined(with: .opacity))
                
                Text("Keep the momentum going!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .transition(.opacity)
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.currentStreak)
        }
    }
    
    private var calendarSection: some View {
        VStack(spacing: 15) {
            Text("STREAK CALENDAR")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
  
            calendarDaysView()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func calendarDaysView() -> some View {
        let calendar = Calendar.current
        let today = viewModel.currentDate
        
        guard let startDate = calendar.date(byAdding: .day, value: -2, to: today) else {
            return AnyView(EmptyView())
        }
        
        let dateRange = (0..<14).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: startDate)
        }
        
        let firstWeek = Array(dateRange.prefix(7))
        let secondWeek = Array(dateRange.suffix(7))
        
        return AnyView(
            VStack(spacing: 10) {
                HStack {
                    ForEach(0..<7, id: \.self) { index in
                        Text(calendar.shortWeekdaySymbols[calendar.component(.weekday, from: firstWeek[index]) - 1])
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                HStack {
                    ForEach(firstWeek, id: \.self) { date in
                        dayView(for: date, calendar: calendar, today: today, showWeekday: false)
                    }
                }
                
                HStack {
                    ForEach(secondWeek, id: \.self) { date in
                        dayView(for: date, calendar: calendar, today: today, showWeekday: false)
                    }
                }
            }
        )
    }

    private func dayView(for date: Date, calendar: Calendar, today: Date, showWeekday: Bool = true) -> some View {
        let day = calendar.component(.day, from: date)
        let isStreakDay = viewModel.streakDays.contains { calendar.isDate($0, inSameDayAs: date) }
        let isToday = calendar.isDate(date, inSameDayAs: today)
        
        return VStack(spacing: 4) {
            if showWeekday {
                Text(calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1])
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            ZStack {
                if isToday {
                    Circle()
                        .stroke(Color.orange, lineWidth: 2)
                        .frame(width: 32, height: 32)
                }
                
                Circle()
                    .fill(isStreakDay ? Color.green : Color.gray.opacity(0.1))
                    .frame(width: 30, height: 30)
                
                if isStreakDay {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                } else {
                    Text("\(day)")
                        .font(.caption)
                        .foregroundColor(isToday ? .orange : .primary)
                }
            }
            
            if isToday {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 4, height: 4)
            } else {
                Spacer()
                    .frame(height: 4)
            }
        }
        .frame(maxWidth: .infinity)
    }
    private var nextMilestoneSection: some View {
        Group {
            if let nextMilestone = viewModel.getNextMilestone() {
                VStack(spacing: 8) {
                    Text("NEXT MILESTONE")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Image(systemName: nextMilestone.icon)
                            .foregroundColor(nextMilestone.color)
                            .font(.title3)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(nextMilestone.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            ProgressView(value: Double(viewModel.currentStreak), total: Double(nextMilestone.days))
                                .tint(nextMilestone.color)
                                .frame(height: 6)
                            
                            Text("\(viewModel.currentStreak)/\(nextMilestone.days) days")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(nextMilestone.color.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var achievementsSection: some View {
        Group {
            let achieved = viewModel.getAchievedMilestones()
            if !achieved.isEmpty {
                VStack(spacing: 8) {
                    Text("YOUR ACHIEVEMENTS")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(achieved) { milestone in
                                VStack(spacing: 6) {
                                    Image(systemName: milestone.icon)
                                        .foregroundColor(milestone.color)
                                        .font(.title)
                                        .padding(10)
                                        .background(milestone.color.opacity(0.1))
                                        .clipShape(Circle())
                                    
                                    Text("\(milestone.days)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(milestone.color)
                                    
                                    Text("days")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .frame(width: 80)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
    
    private var allMilestonesSection: some View {
        VStack(spacing: 8) {
            Text("ALL MILESTONES")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVStack(spacing: 10) {
                ForEach(viewModel.milestones) { milestone in
                    HStack {
                        Image(systemName: milestone.icon)
                            .foregroundColor(milestone.achieved ? milestone.color : milestone.color.opacity(0.5))
                            .font(.title3)
                        
                        Text(milestone.title)
                            .font(.subheadline)
                            .foregroundColor(milestone.achieved ? .primary : .secondary)
                        
                        Spacer()
                        
                        if milestone.achieved {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Text("\(milestone.days) days")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(milestone.achieved ? milestone.color.opacity(0.1) : Color(.systemBackground))
                    .cornerRadius(10)
                }
            }
        }
    }
    
    private var actionButton: some View {
        Button(action: {
            viewModel.confettiCounter += 1
            viewModel.markDayComplete()
        }) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.white)
                Text("Mark Today Complete")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.orange)
            .cornerRadius(12)
            .shadow(color: Color.orange.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.top, 10)
    }
}

#Preview {
    StreakTrackerView()
}
