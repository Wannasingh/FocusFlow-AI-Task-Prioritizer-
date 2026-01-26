//
//  FocusStatisticsView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct FocusStatisticsView: View {
    @State private var selectedPeriod: StatsPeriod = .week
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                header
                
                // Period Selector
                periodSelector
                
                // Stats Cards
                statsCards
                
                // Chart Placeholder
                chartSection
                
                // Session Breakdown
                sessionBreakdown
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 24)
        }
        .background(colorScheme == .dark ? Color.backgroundDarkAlt : Color.backgroundLight)
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("FOCUS STATISTICS")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            Rectangle()
                .fill(Color.primaryBlue)
                .frame(width: 80, height: 6)
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 2)
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)
    }
    
    // MARK: - Period Selector
    private var periodSelector: some View {
        HStack(spacing: 12) {
            ForEach(StatsPeriod.allCases, id: \.self) { period in
                Button(action: { selectedPeriod = period }) {
                    Text(period.rawValue)
                        .font(.displayBold(12))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedPeriod == period ? Color.primaryBlue : Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .shadow(color: .black, radius: 0, x: selectedPeriod == period ? 0 : 2, y: selectedPeriod == period ? 0 : 2)
                }
            }
        }
    }
    
    // MARK: - Stats Cards
    private var statsCards: some View {
        HStack(spacing: 16) {
            statCard(title: "Total Hours", value: "42.5", color: .neoCyan)
            statCard(title: "Sessions", value: "87", color: .neoMagenta)
        }
    }
    
    private func statCard(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.displayBold(12))
                .foregroundColor(.black)
                .textCase(.uppercase)
            
            Text(value)
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(color)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 3)
        )
        .shadow(color: .black, radius: 0, x: 4, y: 4)
    }
    
    // MARK: - Chart Section
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("WEEKLY TREND")
                .font(.displayBold(14))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            // Simple bar chart placeholder
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<7) { index in
                    VStack(spacing: 4) {
                        Rectangle()
                            .fill(Color.primaryBlue)
                            .frame(width: 32, height: CGFloat.random(in: 40...120))
                            .overlay(
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 2)
                            )
                        
                        Text(["M", "T", "W", "T", "F", "S", "S"][index])
                            .font(.displayBold(10))
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(colorScheme == .dark ? Color.backgroundDarkDeep : Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 3)
            )
            .shadow(color: colorScheme == .dark ? .white : .black, radius: 0, x: 4, y: 4)
        }
    }
    
    // MARK: - Session Breakdown
    private var sessionBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("SESSION BREAKDOWN")
                .font(.displayBold(14))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            VStack(spacing: 12) {
                sessionRow(type: "Deep Work", count: 45, color: .neoCyan)
                sessionRow(type: "Pomodoro", count: 32, color: .neoMagenta)
                sessionRow(type: "Breaks", count: 10, color: .neoLime)
            }
        }
    }
    
    private func sessionRow(type: String, count: Int, color: Color) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
                .overlay(Circle().stroke(Color.black, lineWidth: 2))
            
            Text(type)
                .font(.bodyMedium(16))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            Spacer()
            
            Text("\(count)")
                .font(.displayBold(16))
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
        .padding(16)
        .background(colorScheme == .dark ? Color.backgroundDarkDeep : Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2)
        )
    }
}

enum StatsPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

#Preview {
    FocusStatisticsView()
}
