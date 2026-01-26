//
//  GoalTrackingView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct GoalTrackingView: View {
    @State private var showAddGoal = false
    @Environment(\.colorScheme) var colorScheme
    
    // Mock goals
    @State private var goals: [GoalItem] = [
        GoalItem(title: "Complete 50 Tasks", current: 32, target: 50, unit: "tasks", color: .neoCyan),
        GoalItem(title: "100 Hours Focus Time", current: 67, target: 100, unit: "hours", color: .neoMagenta),
        GoalItem(title: "30 Day Streak", current: 18, target: 30, unit: "days", color: .neoLime)
    ]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    header
                    
                    // Goals List
                    VStack(spacing: 20) {
                        ForEach(goals) { goal in
                            goalCard(goal)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 24)
            }
            .background(colorScheme == .dark ? Color.backgroundDarkAlt : Color.backgroundLight)
            
            // FAB
            fab
        }
        .sheet(isPresented: $showAddGoal) {
            AddGoalView()
        }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("GOALS")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    Rectangle()
                        .fill(Color.primaryGreen)
                        .frame(width: 80, height: 6)
                        .overlay(
                            Rectangle()
                                .stroke(Color.black, lineWidth: 2)
                        )
                }
                
                Spacer()
            }
            
            Text("Track your progress")
                .font(.bodyMedium(16))
                .foregroundColor(.textSecondary)
        }
        .padding(.top, 16)
    }
    
    // MARK: - Goal Card
    private func goalCard(_ goal: GoalItem) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title and Progress
            HStack {
                Text(goal.title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(Int(goal.progress * 100))%")
                    .font(.displayBold(16))
                    .foregroundColor(.black)
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 12)
                        .overlay(
                            Rectangle()
                                .stroke(Color.black, lineWidth: 2)
                        )
                    
                    // Progress
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: geometry.size.width * goal.progress, height: 12)
                }
            }
            .frame(height: 12)
            
            // Stats
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "flag.fill")
                        .font(.system(size: 12, weight: .bold))
                    Text("\(Int(goal.current))/\(Int(goal.target)) \(goal.unit)")
                        .font(.mono(12, weight: .bold))
                }
                .foregroundColor(.black)
                
                Spacer()
                
                if let deadline = goal.deadline {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12, weight: .bold))
                        Text(deadline)
                            .font(.mono(12, weight: .bold))
                    }
                    .foregroundColor(.black)
                }
            }
        }
        .padding(20)
        .background(goal.color)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 3)
        )
        .shadow(color: .black, radius: 0, x: 4, y: 4)
    }
    
    // MARK: - FAB
    private var fab: some View {
        Button(action: { showAddGoal = true }) {
            Image(systemName: "plus")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 64, height: 64)
                .background(Color.primaryGreen)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black, lineWidth: 4)
                )
                .shadow(color: .black, radius: 0, x: 4, y: 4)
        }
        .padding(.trailing, 24)
        .padding(.bottom, 24)
    }
}

// MARK: - Supporting Types
struct GoalItem: Identifiable {
    let id = UUID()
    let title: String
    let current: Double
    let target: Double
    let unit: String
    let color: Color
    var deadline: String? = "Dec 31"
    
    var progress: Double {
        min(current / target, 1.0)
    }
}

struct AddGoalView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Text("Add Goal Form")
                .navigationTitle("New Goal")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                }
        }
    }
}

#Preview {
    GoalTrackingView()
}
