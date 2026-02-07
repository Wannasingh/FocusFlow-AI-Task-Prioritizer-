//
//  DashboardView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct DashboardView: View {
    @State private var showAddTask = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authService: AuthService
    
    // Mock data
    @State private var focusScore = 84
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    header
                    
                    // Focus Score
                    focusScoreSection
                    
                    // Priority Tasks
                    priorityTasksSection
                    
                    // Spacer for bottom nav
                    Spacer(minLength: 40)
                }
            }
            .background(
                LinearGradient(colors: [Color.black.opacity(0.92), Color.indigo.opacity(0.6), Color.purple.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
        }
        .sheet(isPresented: $showAddTask) {
            AddTaskView()
        }
    }
    
    private var userName: String {
        authService.currentUser?.displayName ?? "Ready to Flow?"
    }

    
    // MARK: - Header
    private var header: some View {
        HStack {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.neoYellow.opacity(0.9))
                    .frame(width: 48, height: 48)
                    .overlay(Circle().strokeBorder(.white.opacity(0.4), lineWidth: 1))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(userName)
                        .font(.displayBold(20))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Text("OCT 24")
                        .font(.mono(12, weight: .bold))
                        .foregroundColor(.textSecondary)
                }
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .frame(width: 40, height: 40)
                    .glassBar(cornerRadius: 12)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
    
    // MARK: - Focus Score Section
    private var focusScoreSection: some View {
        FocusScoreView(
            score: focusScore,
            progress: Double(focusScore) / 100.0,
            message: "You are on fire today!"
        )
        .frame(height: 340)
        .glassBackground(cornerRadius: 24)
        .padding(.horizontal, 24)
    }
    
    // MARK: - Priority Tasks Section
    private var priorityTasksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack {
                Text("Priority Tasks")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .italic()
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .overlay(
                        Rectangle()
                            .fill(Color.primaryBlue.opacity(0.8))
                            .frame(height: 12)
                            .offset(y: 8)
                            .skew(x: -12),
                        alignment: .bottomLeading
                    )
                
                Spacer()
                
                Button(action: {}) {
                    Text("View All")
                        .font(.displayBold(14))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .underline(color: .neoLime)
                        .underline()
                }
            }
            .padding(.horizontal, 24)
            
            // Task cards
            VStack(spacing: 24) {
                taskCard1
                taskCard2
                taskCard3
            }
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Task Cards
    private var taskCard1: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("TO DO")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "timer")
                        .font(.system(size: 12, weight: .medium))
                    Text("2h left")
                        .font(.caption.weight(.medium))
                }
                .foregroundStyle(.secondary)
            }
            
            Text("Design System Update")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            HStack {
                HStack(spacing: -8) {
                    Circle().fill(.ultraThinMaterial).frame(width: 32, height: 32)
                    Circle().fill(.ultraThinMaterial).frame(width: 32, height: 32)
                }
                Spacer()
                Button(action: {}) {
                    Text("Start")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.neoCyan)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassBackground(cornerRadius: 20)
    }
    
    private var taskCard2: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("IN PROGRESS")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "hourglass")
                        .font(.system(size: 12, weight: .medium))
                    Text("45m left")
                        .font(.caption.weight(.medium))
                }
                .foregroundStyle(.secondary)
            }
            
            Text("AI Model Training")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            HStack {
                Circle().fill(.ultraThinMaterial).frame(width: 32, height: 32)
                Spacer()
                Button(action: {}) {
                    Text("Resume")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.neoMagenta)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassBackground(cornerRadius: 20)
    }
    
    private var taskCard3: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("10:00 AM")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Scheduled")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            
            Text("Client Meeting")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            HStack {
                HStack(spacing: -8) {
                    Circle().fill(.ultraThinMaterial).frame(width: 32, height: 32)
                    Circle().fill(.ultraThinMaterial).frame(width: 32, height: 32)
                    Circle().fill(.ultraThinMaterial).frame(width: 32, height: 32)
                        .overlay(Text("+2").font(.caption2.bold()).foregroundStyle(.secondary))
                }
                Spacer()
                Button(action: {}) {
                    Text("Details")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .glassBar(cornerRadius: 10)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassBackground(cornerRadius: 20)
    }
    
    // MARK: - FAB
    private var floatingActionButton: some View {
        Button(action: { showAddTask = true }) {
            Image(systemName: "plus")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 64, height: 64)
                .background(Color.primaryBlue)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black, lineWidth: 2)
                )
                .shadow(color: colorScheme == .dark ? .white : .black, radius: 0, x: 4, y: 4)
        }
        .offset(x: -24, y: -100)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

// MARK: - Triangle Shape
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Skew Extension
extension View {
    func skew(x: CGFloat = 0, y: CGFloat = 0) -> some View {
        self.transformEffect(CGAffineTransform(a: 1, b: y, c: x, d: 1, tx: 0, ty: 0))
    }
}

// MARK: - Add Task View
struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = TaskViewModel()
    
    @State private var title = ""
    @State private var description = ""
    @State private var category = Models.TaskCategory.work
    @State private var dueDate = Date()
    @State private var priority = Models.TaskPriority.medium
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details").font(.displayBold(12))) {
                    TextField("Title", text: $title)
                        .font(.bodyMedium(16))
                    
                    ZStack(alignment: .topLeading) {
                        if description.isEmpty {
                            Text("Description (Optional)")
                                .foregroundColor(.gray.opacity(0.5))
                                .padding(.top, 8)
                        }
                        TextEditor(text: $description)
                            .frame(minHeight: 100)
                    }
                    .font(.bodyMedium(16))
                }
                
                Section(header: Text("Categorization").font(.displayBold(12))) {
                    Picker("Category", selection: $category) {
                        ForEach(Models.TaskCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue.capitalized).tag(cat)
                        }
                    }
                    
                    Picker("Manual Priority", selection: $priority) {
                        ForEach(Models.TaskPriority.allCases, id: \.self) { prio in
                            Text(prio.rawValue.capitalized).tag(prio)
                        }
                    }
                }
                
                Section(header: Text("Schedule").font(.displayBold(12))) {
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
                
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView("AI is analyzing priority...")
                            .font(.displayBold(14))
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .font(.displayBold(14))
                        .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        Task {
                            await viewModel.createTask(
                                title: title,
                                description: description.isEmpty ? nil : description,
                                category: category,
                                dueDate: dueDate,
                                priority: priority
                            )
                            dismiss()
                        }
                    }
                    .font(.displayBold(14))
                    .foregroundColor(.black)
                    .disabled(title.isEmpty || viewModel.isLoading)
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}

