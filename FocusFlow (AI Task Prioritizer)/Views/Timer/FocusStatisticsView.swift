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
                    .glassBackground(cornerRadius: 20)
                
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
        .background(
            LinearGradient(colors: [Color.black.opacity(0.92), Color.indigo.opacity(0.6), Color.purple.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
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
        HStack(spacing: 10) {
            ForEach(StatsPeriod.allCases, id: \.self) { period in
                Button(action: { selectedPeriod = period }) {
                    if selectedPeriod == period {
                        Text(period.rawValue)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10).fill(Color.neoCyan)
                            )
                            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.white.opacity(0.25), lineWidth: 1))
                    } else {
                        Text(period.rawValue)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.white.opacity(0.25), lineWidth: 1))
                    }
                }
                .buttonStyle(PlainButtonStyle())
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
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .glassBackground(cornerRadius: 16)
    }

    // MARK: - Chart Section
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("WEEKLY TREND")
                .font(.displayBold(14))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            // Simple bar chart placeholder
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<7, id: \.self) { index in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.neoCyan.opacity(0.9))
                            .frame(width: 28, height: CGFloat([60, 80, 45, 100, 70, 90, 55][index]))
                        Text(["M", "T", "W", "T", "F", "S", "S"][index])
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .glassBackground(cornerRadius: 16)
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
                .frame(width: 10, height: 10)
            Text(type)
                .font(.bodyMedium(16))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
            Text("\(count)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
        .padding(14)
        .glassSubtle(cornerRadius: 12)
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
