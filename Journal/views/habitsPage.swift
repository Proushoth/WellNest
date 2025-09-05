//
//  habitsPage.swift
//  Journal
//
//  Created by Proushoth Koushal on 8/19/25.
//

import SwiftUI


struct Habit: Identifiable {
    let id = UUID()
    let title: String
    let frequency: String
    let streak: String
    var progress: Double
    var completedToday: Bool
}

struct habitsPage: View {
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    
    let filters = ["All", "Active", "Completed"]
    
    @State private var habits: [Habit] = [
        Habit(title: "Drink 8 glasses of water", frequency: "Daily", streak: "Streak: 5 days", progress: 0.65, completedToday: true),
        Habit(title: "Meditate for 10 minutes", frequency: "Daily", streak: "Streak: 14 days", progress: 0.45, completedToday: false),
        Habit(title: "Evening walk", frequency: "5x per week", streak: "Progress: 3 / 5", progress: 0.60, completedToday: true)
    ]
    
    var body: some View {
        NavigationStack {
           
            
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        
                        Text("Habits")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search habits...", text: $searchText)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        Picker("Filters", selection: $selectedFilter) {
                            ForEach(filters, id: \.self) { filter in
                                Text(filter)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        ForEach(habits) { habit in
                            HabitCard(habit: habit)
                        }
                        

                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        Spacer(minLength: 80)
                    }
                    .padding()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            
                        }) {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            }
        
            }
        }
    }



struct HabitCard: View {
    let habit: Habit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(habit.title)
                    .font(.headline)
                Spacer()
                Toggle("", isOn: .constant(habit.completedToday))
                    .labelsHidden()
            }
            
            HStack {
                Text(habit.frequency)
                Spacer()
                Text(habit.streak)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            ProgressView(value: habit.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    habitsPage()
}
