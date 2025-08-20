//
//  createGoals.swift
//  Journal
//
//  Created by proushoth koushal on 8/20/25.
//

import SwiftUI

struct createGoals: View {
    @State private var goalName = ""
    @State private var goalCategory = ""
    @State private var goalType = "Numeric Target"
    @State private var goalDescription = ""
    @State private var target = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var notifications = "Numeric Target"
    
    let goalTypes = ["Numeric Target", "Habit"]
    let categories = ["Health", "Work", "Personal", "Study"]
    let targets = ["Daily", "Weekly", "Monthly"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Goals")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 14) {
                        
                        TextField("Goal name", text: $goalName)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                        
                        Menu {
                            ForEach(categories, id: \.self) { category in
                                Button(category) {
                                    goalCategory = category
                                }
                            }
                        } label: {
                            HStack {
                                Text(goalCategory.isEmpty ? "Goal category" : goalCategory)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Goal type:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                ForEach(goalTypes, id: \.self) { type in
                                    HStack {
                                        Image(systemName: goalType == type ? "circle.fill" : "circle")
                                            .foregroundColor(goalType == type ? .blue : .gray)
                                        Text(type)
                                    }
                                    .onTapGesture {
                                        goalType = type
                                    }
                                    Spacer()
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Goal description:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            TextEditor(text: $goalDescription)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .font(.system(size: 15, design: .rounded))
                        }
                        
                        Menu {
                            ForEach(targets, id: \.self) { option in
                                Button(option) {
                                    target = option
                                }
                            }
                        } label: {
                            HStack {
                                Text(target.isEmpty ? "Target" : target)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        
                        DatePicker("Start date:", selection: $startDate, displayedComponents: .date)
                            .font(.system(size: 15, design: .rounded))
                        
                        DatePicker("End date:", selection: $endDate, displayedComponents: .date)
                            .font(.system(size: 15, design: .rounded))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notifications:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                HStack {
                                    Image(systemName: notifications == "Numeric Target" ? "circle.fill" : "circle")
                                        .foregroundColor(notifications == "Numeric Target" ? .blue : .gray)
                                    Text("Numeric Target")
                                }
                                .onTapGesture { notifications = "Numeric Target" }
                                
                                Spacer()
                                
                                HStack {
                                    Image(systemName: notifications == "Habit" ? "circle.fill" : "circle")
                                        .foregroundColor(notifications == "Habit" ? .blue : .gray)
                                    Text("Habit")
                                }
                                .onTapGesture { notifications = "Habit" }
                            }
                        }
                    }
                    
                    Button(action: {
                        // Save action
                    }) {
                        Text("Save")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
        }
    }
}

#Preview {
    createGoals()
}
