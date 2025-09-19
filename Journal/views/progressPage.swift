//
//  progressPage.swift
//  Journal
//
//  Created by proushoth koushal on 8/19/25.
//

import SwiftUI
import Charts
import CoreData

struct progressPage: View {
    @State private var showEditProfile = false
    
    @FetchRequest(
        entity: Goal.entity(),
        sortDescriptors: []
    ) private var goals: FetchedResults<Goal>
    
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    ) private var habits: FetchedResults<Habit>
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Progress")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.primary)
                                
                                Text("Track your journey")
                                    .font(.subheadline)
                                    .foregroundColor(Color.secondary)
                            }
                            Spacer()
                            
                            Button(action: { showEditProfile = true }) {
                                Image(systemName: "person.circle")
                                    .font(.system(size: 24))
                                    .foregroundColor(.blue)
                            }
                            
                            HStack(spacing: 12) {
                                SummaryCard(
                                    title: "Goals",
                                    count: goals.count,
                                    color: Color.blue,
                                    icon: "target"
                                )
                                
                                SummaryCard(
                                    title: "Habits",
                                    count: habits.count,
                                    color: Color.green,
                                    icon: "repeat"
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    ChartSection(
                        title: "Goals Progress",
                        subtitle: "Your current goal completion status",
                        icon: "target",
                        color: Color.blue,
                        isEmpty: goals.isEmpty,
                        emptyMessage: "No goals yet. Create your first goal to see progress!"
                    ) {
                        Chart(goals) { goal in
                            BarMark(
                                x: .value("Goal", String(goal.title?.prefix(12) ?? "")),
                                y: .value("Progress", goal.progress)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.4)],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .cornerRadius(6)
                        }
                        .frame(height: 200)
                    }
                    
                    ChartSection(
                        title: "Habits Overview",
                        subtitle: "Your established habits",
                        icon: "repeat",
                        color: Color.green,
                        isEmpty: habits.isEmpty,
                        emptyMessage: "No habits yet. Start building consistent habits!"
                    ) {
                        Chart(habits) { habit in
                            BarMark(
                                x: .value("Habit", String(habit.name?.prefix(12) ?? "")),
                                y: .value("Active", 1)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.green.opacity(0.8), Color.green.opacity(0.4)],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .cornerRadius(6)
                        }
                        .frame(height: 200)
                    }
                }
                .padding(.bottom, 20)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .sheet(isPresented: $showEditProfile) {
                editProfile()
            }
        }
    }
}

struct SummaryCard: View {
    let title: String
    let count: Int
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
            
            Text("\(count)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.primary)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(Color.secondary)
        }
        .frame(width: 60, height: 60)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct ChartSection<Content: View>: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let isEmpty: Bool
    let emptyMessage: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 28, height: 28)
                    .background(
                        Circle()
                            .fill(color.opacity(0.15))
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                }
                
                Spacer()
            }
            
            if isEmpty {
                EmptyStateView(message: emptyMessage, color: color)
            } else {
                content
                    .padding(.horizontal, 4)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .padding(.horizontal, 20)
    }
}

struct EmptyStateView: View {
    let message: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 40))
                .foregroundColor(color.opacity(0.6))
            
            Text(message)
                .font(.body)
                .foregroundColor(Color.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(height: 160)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    progressPage()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
