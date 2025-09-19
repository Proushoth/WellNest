//
//  homePage.swift
//  Journal
//
//  Created by proushoth koushal on 8/19/25.
//
import SwiftUI
import UIKit
import UserNotifications
import CoreData


struct homePage: View {
    @State private var showJournalPage = false
    @State private var showHabitsPage = false
    @State private var showGoalsPage = false
    @State private var showMoodTrendPage = false  // Add this line
    let userName = "Jphn"
    
    // Fetch goals from Core Data
    @FetchRequest(
        entity: GoalEntity.entity(),
        sortDescriptors: []
    ) private var goals: FetchedResults<GoalEntity>
    
    // Fetch habits from Core Data (assuming you have a HabitEntity)
    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: []
    ) private var habits: FetchedResults<Habit>
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("👋 Good Afternoon, \(userName)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        Text("“Stay mindful, you’re doing great today!”")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)
                    .shadow(color: .purple.opacity(0.08), radius: 8, x: 0, y: 4)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("🗓 Today’s Snapshot")
                            .font(.headline)
                        HStack(spacing: 60) {
                            StatCard(
                                title: "Habits",
                                value: "\(habits.filter { !$0.isCompleted }.count)/\(habits.count)",
                                color: .blue
                            )
                            StatCard(
                                title: "Journals",
                                value: "1", // Update if you have journal count
                                color: .purple
                            )
                            StatCard(
                                title: "Goals",
                                value: goals.isEmpty ? "0%" : "\(Int((goals.map { $0.progress }.reduce(0, +) / Double(goals.count)) * 100))%",
                                color: .orange
                            )
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)
                    .shadow(color: .blue.opacity(0.08), radius: 8, x: 0, y: 4)
                    
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("📊 Progress Overview")
                            .font(.headline)
                        HStack(spacing: 30) {
                            OverviewCard(title: "Habit\nChart", color: .blue)
                            Button(action: {
                                showMoodTrendPage = true
                            }) {
                                OverviewCard(title: "Mood\nTrend", color: .green)
                            }
                            OverviewCard(title: "Goal\nRing", color: .orange)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)
                    .shadow(color: .green.opacity(0.08), radius: 8, x: 0, y: 4)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 14) {
                        Text("📝 Quick Actions")
                            .font(.headline)
                        HStack(spacing: 18) {
                            Button(action: {
                                showJournalPage = true
                            }) {
                                Text("+ Journal ")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.85), Color.purple.opacity(0.65)]), startPoint: .leading, endPoint: .trailing))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.purple.opacity(0.12), radius: 4, x: 0, y: 2)
                            }
                            Button(action: {
                                showHabitsPage = true
                            }) {
                                Text("+  Habit")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.85), Color.green.opacity(0.65)]), startPoint: .leading, endPoint: .trailing))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.green.opacity(0.12), radius: 4, x: 0, y: 2)
                            }
                            Button(action: {
                                showGoalsPage = true
                            }) {
                                Text("+  Goal")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.85), Color.orange.opacity(0.65)]), startPoint: .leading, endPoint: .trailing))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.orange.opacity(0.12), radius: 4, x: 0, y: 2)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)
                    .shadow(color: .orange.opacity(0.08), radius: 8, x: 0, y: 4)
                    
                    // Active Goals
                    VStack(alignment: .leading, spacing: 14) {
                        Text("🎯 Active Goals")
                            .font(.headline)
                        GoalProgressView(title: "Read 12 books", progress: 0.25)
                        GoalProgressView(title: "Run 5km weekly", progress: 0.60)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)
                    .shadow(color: .blue.opacity(0.08), radius: 8, x: 0, y: 4)
                    
                    // Upcoming Reminders
                    VStack(alignment: .leading, spacing: 10) {
                        Text("🔔 Upcoming Reminders")
                            .font(.headline)
                        ReminderRow(text: "Meditate at 8:00 PM")
                        ReminderRow(text: "Weekly Reflection: Friday")
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)
                    .shadow(color: .purple.opacity(0.08), radius: 8, x: 0, y: 4)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 18)
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.08), Color.blue.opacity(0.06)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            )
            .navigationTitle("🌿 Wellness Journal")
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $showJournalPage) {
                journalPage()
            }
            .navigationDestination(isPresented: $showHabitsPage) {
                habitsPage()
            }
            .navigationDestination(isPresented: $showGoalsPage) {
                MoodTrend()
            }
        }
    }
}

struct StatCard: View {
    var title: String
    var value: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 70, height: 60)
        .background(color.opacity(0.08))
        .cornerRadius(12)
    }
}

// Update OverviewCard to be tappable
struct OverviewCard: View {
    var title: String
    var color: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(color.opacity(0.15))
            .frame(width: 90, height: 90)
            .overlay(
                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(color)
            )
    }
}

struct ActionButton: View {
    var label: String
    var color: Color
    
    var body: some View {
        Button(action: {}) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [color.opacity(0.85), color.opacity(0.65)]), startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: color.opacity(0.12), radius: 4, x: 0, y: 2)
        }
    }
}

struct GoalProgressView: View {
    var title: String
    var progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .frame(height: 8)
                .background(Color.blue.opacity(0.08))
                .cornerRadius(4)
            Text("Progress: \(Int(progress * 100))%")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct ReminderRow: View {
    var text: String
    var body: some View {
        HStack {
            Image(systemName: "bell")
                .foregroundColor(.purple)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    homePage()
}
