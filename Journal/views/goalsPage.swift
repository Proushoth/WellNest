//
//  goalsPage.swift
//  Journal
//
//  Created by proushoth koushal on 8/19/25.
//

import SwiftUI

struct Goal: Identifiable {
    let id = UUID()
    let title: String
    let progress: Double
    let streak: String?
    let targetDate: String
    let color: Color
}

struct goalsPage: View {
    @State private var selectedFilter = "All"
    @State private var searchText = ""
    
    let filters = ["All", "Active", "Completed"]
    
    let goals = [
        Goal(title: "Goal card 1", progress: 0.6, streak: nil, targetDate: "12.05.20XX", color: .green),
        Goal(title: "Goal card 2", progress: 0.2, streak: nil, targetDate: "12.05.20XX", color: .green),
        Goal(title: "Goal card 3", progress: 1.0, streak: "3 days", targetDate: "Recurring", color: .orange)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Goals")
                .font(.title)
                .bold()
                .padding(.horizontal)
            
            TextField("Search halls", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            HStack {
                ForEach(filters, id: \.self) { filter in
                    Button(action: {
                        selectedFilter = filter
                    }) {
                        Text(filter)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(selectedFilter == filter ? Color(.systemGray5) : Color.clear)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(goals) { goal in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "target")
                                Text(goal.title)
                                    .font(.headline)
                                Spacer()
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray4))
                                    .frame(width: 40, height: 20)
                            }
                            
                            if let streak = goal.streak {
                                Text("Streak : \(streak)")
                                    .font(.subheadline)
                                ProgressView(value: goal.progress)
                                    .progressViewStyle(LinearProgressViewStyle(tint: goal.color))
                            } else {
                                Text("Progress : \(Int(goal.progress * 100))%")
                                    .font(.subheadline)
                                ProgressView(value: goal.progress)
                                    .progressViewStyle(LinearProgressViewStyle(tint: goal.color))
                            }
                            
                            Text("Target date: \(goal.targetDate)")
                                .font(.subheadline)
                            
                            HStack {
                                Button("Edit") {}
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 6)
                                    .background(Color(.systemGray5))
                                    .cornerRadius(6)
                                Button("Delete") {}
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 6)
                                    .background(Color(.systemGray5))
                                    .cornerRadius(6)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                }
            }
            
            Button(action: {}) {
                Text("Add goals +")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
            .padding()
        }
    }
}

#Preview {
    goalsPage()
}
