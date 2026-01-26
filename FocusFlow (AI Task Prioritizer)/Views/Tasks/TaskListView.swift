//
//  TaskListView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct TaskListView: View {
    @State private var selectedFilter: TaskFilter = .all
    @State private var showAddTask = false
    @Environment(\.colorScheme) var colorScheme
    
    // Mock tasks
    @State private var tasks: [TaskItem] = [
        TaskItem(title: "Draft Q3 Report", category: Models.TaskCategory.work, time: "Today, 10:00 AM", priority: "High Priority", color: .neoCyan),
        TaskItem(title: "Email Marketing Team", category: Models.TaskCategory.marketing, time: "Today, 12:30 PM", priority: "Marketing", color: .neoMagenta),
        TaskItem(title: "Review Codebase", category: Models.TaskCategory.dev, time: "Today, 2:00 PM", priority: "Dev", color: .neoOrange),
        TaskItem(title: "Gym Session", category: Models.TaskCategory.health, time: "Today, 6:00 PM", priority: "Health", color: .neoPurple)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            header
            
            // Filters
            filterSection
            
            // Task List
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(tasks) { task in
                        taskRow(task)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .background(colorScheme == .dark ? Color.backgroundDarkDeep : Color.backgroundLight)
        }
        .overlay(alignment: .bottomTrailing) {
            fab
        }
        .background(colorScheme == .dark ? Color.backgroundDarkDeep : Color.backgroundLight)
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showAddTask) {
            AddTaskView()
        }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Logo
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .shadow(color: .black, radius: 0, x: 2, y: 2)
                
                Text("FOCUSFLOW")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Spacer()
                
                // Notifications
                Button(action: {}) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .frame(width: 48, height: 48)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .shadow(color: .black, radius: 0, x: 2, y: 2)
                        
                        Circle()
                            .fill(Color.primaryGreen)
                            .frame(width: 12, height: 12)
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            .offset(x: -4, y: 4)
                    }
                }
            }
            
            // Title
            Text("MY TASKS")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .tracking(-1)
            
            Rectangle()
                .fill(Color.primaryGreen)
                .frame(width: 96, height: 8)
                .overlay(
                    Rectangle()
                        .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2)
                )
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 8)
        .background(colorScheme == .dark ? Color.backgroundDarkDeep : Color.backgroundLight)
    }
    
    // MARK: - Filter Section
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TaskFilter.allCases, id: \.self) { filter in
                    filterChip(filter)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(colorScheme == .dark ? Color.backgroundDarkDeep : Color.backgroundLight)
    }
    
    private func filterChip(_ filter: TaskFilter) -> some View {
        Button(action: { selectedFilter = filter }) {
            HStack(spacing: 6) {
                Text(filter.rawValue.uppercased())
                    .font(.displayBold(12))
                    .foregroundColor(.black)
                
                if let icon = filter.icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(selectedFilter == filter ? Color.primaryGreen : Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 2)
            )
            .shadow(color: .black, radius: 0, x: 2, y: 2)
        }
    }
    
    // MARK: - Task Row
    private func taskRow(_ task: TaskItem) -> some View {
        HStack(alignment: .top, spacing: 16) {
            // Checkbox
            Button(action: {}) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.black, lineWidth: 2)
                    )
            }
            .padding(.top, 4)
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 16, weight: .medium))
                    Text(task.time)
                        .font(.bodyMedium(14))
                }
                .foregroundColor(.black.opacity(0.8))
            }
            
            Spacer()
            
            // More button
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .rotationEffect(.degrees(90))
                    .frame(width: 32, height: 32)
            }
        }
        .padding(16)
        .background(task.color)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 3)
        )
        .shadow(color: .black, radius: 0, x: 4, y: 4)
        .overlay(alignment: .topLeading) {
            Text(task.priority)
                .font(.displayBold(10))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.black)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .offset(x: 16, y: -8)
        }
        .overlay(alignment: .bottomTrailing) {
            if task.isAIPrioritized {
                HStack(spacing: 4) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 12, weight: .bold))
                    Text("AI PRIORITIZED")
                        .font(.displayBold(8))
                }
                .foregroundColor(.black)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.3))
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                )
                .offset(x: -16, y: -16)
            }
        }
    }
    
    // MARK: - FAB
    private var fab: some View {
        Button(action: { showAddTask = true }) {
            Image(systemName: "plus")
                .font(.system(size: 32, weight: .bold))
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
        .padding(.trailing, 16)
        .padding(.bottom, 96)
    }
}

// MARK: - Supporting Types
enum TaskFilter: String, CaseIterable {
    case all = "All"
    case deepWork = "Deep Work"
    case quickWins = "Quick Wins"
    case pending = "Pending"
    
    var icon: String? {
        switch self {
        case .all: return nil
        case .deepWork: return "brain.head.profile"
        case .quickWins: return "timer"
        case .pending: return nil
        }
    }
}

struct TaskItem: Identifiable {
    let id = UUID()
    let title: String
    let category: Models.TaskCategory
    let time: String
    let priority: String
    let color: Color
    var isAIPrioritized: Bool = true
}

#Preview {
    TaskListView()
}
