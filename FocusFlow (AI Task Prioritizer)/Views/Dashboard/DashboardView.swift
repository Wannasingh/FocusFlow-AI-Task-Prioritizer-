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
            .background(colorScheme == .dark ? Color.backgroundDarkAlt : Color.backgroundLight)
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
                // Avatar
                Circle()
                    .fill(Color.neoYellow)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Circle()
                            .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2)
                    )
                    .shadow(color: colorScheme == .dark ? .white : .black, radius: 0, x: 4, y: 4)
                
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
            
            // Notifications
            Button(action: {}) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 40, height: 40)
                    .background(Color.clear)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2)
                    )
            }
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
        NeubrutalistCard(backgroundColor: .neoCyan) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 0, x: 2, y: 2)
                        
                        Text("TO DO")
                            .font(.displayBold(10))
                            .foregroundColor(.black)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.white)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "timer")
                            .font(.system(size: 14, weight: .bold))
                        Text("2h left")
                            .font(.mono(12, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black)
                    .cornerRadius(4)
                }
                
                Text("Design System Update")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(.black)
                    .tracking(-0.5)
                
                HStack {
                    HStack(spacing: -12) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("START")
                            .font(.displayBold(12))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            .background(Color.black)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.clear, lineWidth: 2)
                            )
                    }
                }
            }
        }
    }
    
    private var taskCard2: some View {
        NeubrutalistCard(backgroundColor: .neoMagenta) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    HStack(spacing: 8) {
                        Triangle()
                            .fill(Color.white)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Triangle()
                                    .stroke(Color.black, lineWidth: 2)
                            )
                        
                        Text("IN PROGRESS")
                            .font(.displayBold(10))
                            .foregroundColor(.black)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.white)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "hourglass")
                            .font(.system(size: 14, weight: .bold))
                        Text("45m left")
                            .font(.mono(12, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black)
                    .cornerRadius(4)
                }
                
                Text("AI Model Training")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(.black)
                    .tracking(-0.5)
                
                HStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("RESUME")
                            .font(.displayBold(12))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            .background(Color.black)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
    
    private var taskCard3: some View {
        NeubrutalistCard(backgroundColor: .neoLime) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 24, height: 24)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                            .shadow(color: Color.black.opacity(0.2), radius: 0, x: 1, y: 1)
                        
                        Text("10:00 AM")
                            .font(.displayBold(10))
                            .foregroundColor(.black)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.white)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    
                    Spacer()
                    
                    Text("Scheduled")
                        .font(.mono(12, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        )
                        .cornerRadius(4)
                }
                
                Text("Client Meeting")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(.black)
                    .tracking(-0.5)
                
                HStack {
                    HStack(spacing: -12) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        
                        Circle()
                            .fill(Color.black)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Text("+2")
                                    .font(.displayBold(10))
                                    .foregroundColor(.white)
                            )
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("DETAILS")
                            .font(.displayBold(12))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                }
            }
        }
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

// MARK: - Placeholder Add Task View
struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Text("Add Task Form")
                .navigationTitle("New Task")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                }
        }
    }
}

#Preview {
    DashboardView()
}
