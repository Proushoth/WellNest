//
//  homePage.swift
//  Journal
//
//  Created by proushoth koushal on 8/19/25.
//

import SwiftUI

struct homePage: View {
    @State private var selectedTab = 0
    let userName = "Proushoth"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("👋 Good Afternoon, \(userName)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("“Stay mindful, you’re doing great today!”")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("🗓 Today’s Snapshot")
                            .font(.headline)
                        Text("- Habits Completed: 3 / 5")
                        Text("- Journal Entries: 1")
                        Text("- Goal Progress: 65%")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📊 Progress Overview")
                            .font(.headline)
                        
                        HStack(spacing: 10) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .overlay(Text("Habit\nChart").font(.caption))
                            
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .overlay(Text("Mood\nTrend").font(.caption))
                            
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .overlay(Text("Goal\nRing").font(.caption))
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📝 Quick Actions")
                            .font(.headline)
                        HStack(spacing: 15) {
                            ActionButton(label: "+ New Journal", color: .blue)
                            ActionButton(label: "+ Add Habit", color: .green)
                            ActionButton(label: "+ Add Goal", color: .orange)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🎯 Active Goals")
                            .font(.headline)
                        
                        GoalProgressView(title: "Read 12 books", progress: 0.25)
                        GoalProgressView(title: "Run 5km weekly", progress: 0.60)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Upcoming Reminders
                    VStack(alignment: .leading, spacing: 8) {
                        Text("🔔 Upcoming Reminders")
                            .font(.headline)
                        Text("- Meditate at 8:00 PM")
                        Text("- Weekly Reflection: Friday")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("🌿 Wellness Journal")
            .toolbar(.hidden, for: .navigationBar)
            
       
        }
    }
}


struct ActionButton: View {
    var label: String
    var color: Color
    
    var body: some View {
        Button(action: {}) {
            Text(label)
                .font(.subheadline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

struct GoalProgressView: View {
    var title: String
    var progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            Text("Progress: \(Int(progress * 100))%")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}


#Preview {
    homePage()
}
