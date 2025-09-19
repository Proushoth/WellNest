//
//  createGoals.swift
//  Journal
//
//  Created by proushoth koushal on 8/20/25.
//

import SwiftUI
import CoreData

struct createGoals: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var progress: Double = 0.0
    @State private var streak: String = ""
    @State private var targetDate = Date()
    @State private var color: String = "green"

    let colors = ["green", "orange", "blue", "purple"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Title", text: $title)
                    Slider(value: $progress, in: 0...1, step: 0.01) {
                        Text("Progress")
                    }
                    Text("Progress: \(Int(progress * 100))%")
                        .font(.caption)
                    TextField("Streak (optional)", text: $streak)
                    DatePicker("Target Date", selection: $targetDate, displayedComponents: .date)
                    Picker("Color", selection: $color) {
                        ForEach(colors, id: \.self) { color in
                            Text(color.capitalized)
                        }
                    }
                }
                Section {
                    Button("Save Goal") {
                        addGoal()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Create Goal")
        }
    }

    private func addGoal() {
        let newGoal = GoalEntity(context: viewContext)
        newGoal.title = title
        newGoal.progress = progress
        newGoal.streak = streak.isEmpty ? nil : streak
        newGoal.targetDate = DateFormatter.localizedString(from: targetDate, dateStyle: .short, timeStyle: .none)
        newGoal.color = color

        do {
            try viewContext.save()
            dismiss()
        } catch {
          
        }
    }
}

#Preview {
    createGoals()
}
