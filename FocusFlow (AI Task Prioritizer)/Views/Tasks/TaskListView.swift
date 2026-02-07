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
    @State private var searchText: String = ""
    @Environment(\.colorScheme) var colorScheme

    // Mock tasks
    @State private var tasks: [TaskItem] = [
        TaskItem(title: "Draft Q3 Report", category: Models.TaskCategory.work, time: "Today, 10:00 AM", priority: "High Priority", color: .neoCyan),
        TaskItem(title: "Email Marketing Team", category: Models.TaskCategory.marketing, time: "Today, 12:30 PM", priority: "Marketing", color: .neoMagenta),
        TaskItem(title: "Review Codebase", category: Models.TaskCategory.dev, time: "Today, 2:00 PM", priority: "Dev", color: .neoOrange),
        TaskItem(title: "Gym Session", category: Models.TaskCategory.health, time: "Today, 6:00 PM", priority: "Health", color: .neoPurple)
    ]
    
    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color.backgroundDarkDeep : Color.backgroundLight)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                searchBar
                filterSection
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(tasks.enumerated()), id: \.element.id) { index, task in
                            taskRow(task)
                            if index < tasks.count - 1 {
                                Divider()
                                    .background(Color.primary.opacity(0.1))
                                    .padding(.leading, 56)
                            }
                        }
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .glassBackground(cornerRadius: 24)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }
            }
        }
        .overlay(alignment: .bottomTrailing) { fab }
        .sheet(isPresented: $showAddTask) { AddTaskView() }
    }
    
    // MARK: - Header (Material only, minimal)
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.primary)
                    .frame(width: 40, height: 40)
                    .glassBar(cornerRadius: 10)

                Text("FocusFlow")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                Spacer()

                Button(action: {}) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 44, height: 44)
                            .glassBar(cornerRadius: 12)
                        Circle()
                            .fill(Color.red.opacity(0.8))
                            .frame(width: 8, height: 8)
                            .offset(x: -2, y: 2)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }

            Text("My Tasks")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .glassBackground(cornerRadius: 20)
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    // MARK: - Search Bar (ultraThinMaterial)
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
            TextField("Search tasks...", text: $searchText)
                .font(.system(size: 16))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .glassBar(cornerRadius: 14)
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    // MARK: - Filter (Material only, ไม่ใส่สี)
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(TaskFilter.allCases, id: \.self) { filter in
                    filterChip(filter)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
        }
        .padding(.top, 4)
    }

    private func filterChip(_ filter: TaskFilter) -> some View {
        Button(action: { selectedFilter = filter }) {
            Text(filter.rawValue)
                .font(.system(size: 13, weight: selectedFilter == filter ? .semibold : .medium))
                .foregroundStyle(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(selectedFilter == filter ? .thinMaterial : .ultraThinMaterial)
                )
                .overlay(Capsule().strokeBorder(Color.primary.opacity(selectedFilter == filter ? 0.12 : 0.06), lineWidth: 1))
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Task Row (Material, minimal)
    private func taskRow(_ task: TaskItem) -> some View {
        HStack(alignment: .center, spacing: 14) {
            Button(action: {}) {
                Circle()
                    .strokeBorder(Color.primary.opacity(0.3), lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(.ultraThinMaterial))
            }
            .buttonStyle(PlainButtonStyle())

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 12, weight: .medium))
                    Text(task.time)
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
            }

            Spacer()

            if task.isAIPrioritized {
                Image(systemName: "sparkles")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 14)
    }

    // MARK: - FAB (Material, ไม่ใส่พื้นสี)
    private var fab: some View {
        Button(action: { showAddTask = true }) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.primary)
                .frame(width: 56, height: 56)
                .background(.thinMaterial, in: Circle())
                .overlay(Circle().strokeBorder(Color.primary.opacity(0.1), lineWidth: 1))
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.trailing, 20)
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

