//
//  goalsPage.swift
//  Journal
//
//  Created by proushoth koushal on 8/19/25.
//

import SwiftUI
import CoreData

struct goalsPage: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // Auto-updating fetch request
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GoalEntity.targetDate, ascending: true)],
        animation: .spring(response: 0.6, dampingFraction: 0.8))
    private var goals: FetchedResults<GoalEntity>
    
    @State private var selectedFilter = "All"
    @State private var searchText = ""
    @State private var showCreateGoal = false
    @State private var animateCards = false
    @State private var goalToEdit: GoalEntity?
    @State private var showEditSheet = false
    
    let filters = ["All", "Active", "Completed"]
    
    // Filtering logic
    var filteredGoals: [GoalEntity] {
        goals.filter { goal in
            let matchesFilter = selectedFilter == "All" ||
                               (selectedFilter == "Completed" ? goal.progress >= 1.0 : goal.progress < 1.0)
            let matchesSearch = searchText.isEmpty ||
                               (goal.title?.localizedCaseInsensitiveContains(searchText) ?? false)
            return matchesFilter && matchesSearch
        }
    }
    
    // Computed properties for gradients
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.purple.opacity(0.1),
                Color.blue.opacity(0.05),
                Color.clear
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var titleGradient: LinearGradient {
        LinearGradient(
            colors: [.primary, .secondary],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var statsGradient: LinearGradient {
        LinearGradient(
            colors: [.purple.opacity(0.3), .blue.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var buttonGradient: LinearGradient {
        LinearGradient(
            colors: [.purple, .blue],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Dynamic gradient background
                backgroundGradient
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    // Enhanced Header with stats
                    headerSection
                    
                    // Enhanced Search bar with glass effect
                    searchBar
                    
                    // Enhanced Filter buttons with pill design
                    filterButtons
                    
                    // Enhanced Goals list with better cards
                    goalsList
                }
            }
            .overlay(alignment: .bottomTrailing) {
                floatingAddButton
            }
        }
        .sheet(isPresented: $showCreateGoal) {
            createGoals()
                .environment(\.managedObjectContext, viewContext)
        }
        .sheet(isPresented: $showEditSheet) {
            if let goalToEdit = goalToEdit {
                EditGoalView(goal: goalToEdit)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Goals")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(titleGradient)
                    
                    Text("\(filteredGoals.count) goals")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Stats circle
                ZStack {
                    Circle()
                        .fill(statsGradient)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )
                    
                    VStack(spacing: 2) {
                        Text("\(goals.filter { $0.progress >= 1.0 }.count)")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                        Text("Done")
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search your goals...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 24)
    }
    
    private var filterButtons: some View {
        HStack(spacing: 12) {
            ForEach(filters, id: \.self) { filter in
                filterButton(for: filter)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    private func filterButton(for filter: String) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedFilter = filter
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: filterIcon(for: filter))
                    .font(.system(size: 12, weight: .medium))
                Text(filter)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
            }
            .foregroundColor(selectedFilter == filter ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(selectedFilter == filter ? buttonGradient :
                          LinearGradient(colors: [Color.clear], startPoint: .leading, endPoint: .trailing))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                selectedFilter == filter ? Color.clear : Color.primary.opacity(0.2),
                                lineWidth: 1
                            )
                    )
            )
            .scaleEffect(selectedFilter == filter ? 1.05 : 1.0)
        }
    }
    
    private var goalsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(Array(filteredGoals.enumerated()), id: \.element) { index, goal in
                    GoalCard(
                        goal: goal,
                        onEdit: {
                            goalToEdit = goal
                            showEditSheet = true
                        },
                        onDelete: {
                            deleteGoal(goal)
                        }
                    )
                    .opacity(animateCards ? 1 : 0)
                    .offset(y: animateCards ? 0 : 20)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8)
                        .delay(Double(index) * 0.1),
                        value: animateCards
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 100)
        }
        .onAppear {
            withAnimation {
                animateCards = true
            }
        }
    }
    
    private var floatingAddButton: some View {
        Button(action: {
            showCreateGoal = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                Text("Add Goal")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(buttonGradient)
                    .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
            )
        }
        .scaleEffect(showCreateGoal ? 0.95 : 1.0)
        .animation(.spring(response: 0.3), value: showCreateGoal)
        .padding(24)
    }
    
    // MARK: - Helper Functions
    
    private func filterIcon(for filter: String) -> String {
        switch filter {
        case "All": return "list.bullet"
        case "Active": return "clock"
        case "Completed": return "checkmark.circle"
        default: return "list.bullet"
        }
    }
    
    private func deleteGoal(_ goal: GoalEntity) {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            let context = goal.managedObjectContext ?? viewContext
            context.delete(goal)
            
            do {
                try context.save()
            } catch {
                print("Failed to delete goal: \(error.localizedDescription)")
            }
        }
    }
}

struct GoalCard: View {
    let goal: GoalEntity
    let onEdit: () -> Void
    let onDelete: () -> Void
    @State private var showActions = false
    @State private var showDeleteConfirmation = false
    
    // Computed properties for gradients
    private var iconGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(goal.color ?? "green").opacity(0.3),
                Color(goal.color ?? "green").opacity(0.1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var progressGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(goal.color ?? "green"),
                Color(goal.color ?? "green").opacity(0.7)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            headerSection
            
            // Progress section
            progressSection
            
            // Action buttons
            actionButtons
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.regularMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .scaleEffect(showActions ? 0.98 : 1.0)
        .animation(.spring(response: 0.3), value: showActions)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showActions.toggle()
            }
        }
    }
    
    // MARK: - Card Components
    
    private var headerSection: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon circle
            ZStack {
                Circle()
                    .fill(iconGradient)
                    .frame(width: 44, height: 44)
                
                Image(systemName: goal.progress >= 1.0 ? "checkmark.circle.fill" : "target")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(goal.color ?? "green"))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.title ?? "")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .lineLimit(2)
                
                if let streak = goal.streak, !streak.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                        Text("Streak: \(streak)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            // Progress badge
            progressBadge
        }
    }
    
    private var progressBadge: some View {
        HStack(spacing: 4) {
            Text("\(Int(goal.progress * 100))%")
                .font(.system(size: 14, weight: .bold, design: .rounded))
            Image(systemName: goal.progress >= 1.0 ? "star.fill" : "chevron.right")
                .font(.system(size: 10, weight: .bold))
        }
        .foregroundColor(goal.progress >= 1.0 ? .yellow : .secondary)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.1))
        )
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Progress")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                Spacer()
                Text("Target: \(goal.targetDate ?? "")")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            // Custom progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.secondary.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(progressGradient)
                        .frame(width: geometry.size.width * CGFloat(goal.progress), height: 8)
                        .animation(.easeInOut(duration: 0.5), value: goal.progress)
                }
            }
            .frame(height: 8)
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button("Edit") {
                onEdit()
            }
            .font(.system(size: 14, weight: .medium, design: .rounded))
            .foregroundColor(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.1))
            )
            
            Button("Delete") {
                showDeleteConfirmation = true
            }
            .font(.system(size: 14, weight: .medium, design: .rounded))
            .foregroundColor(.red)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red.opacity(0.1))
            )
            .alert("Delete Goal", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    onDelete()
                }
            } message: {
                Text("Are you sure you want to delete '\(goal.title ?? "this goal")'? This action cannot be undone.")
            }
            
            Spacer()
        }
    }
}

// Edit Goal View
struct EditGoalView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let goal: GoalEntity
    
    @State private var title: String = ""
    @State private var progress: Double = 0.0
    @State private var streak: String = ""
    @State private var targetDate: String = ""
    @State private var selectedColor: String = "green"
    
    let colors = ["green", "blue", "purple", "orange", "red", "pink", "cyan", "yellow"]
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.purple.opacity(0.1),
                Color.blue.opacity(0.05),
                Color.clear
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var saveButtonGradient: LinearGradient {
        LinearGradient(
            colors: [.purple, .blue],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Title
                        formField(title: "Goal Title", text: $title, placeholder: "Enter goal title")
                        
                        // Progress
                        progressSlider
                        
                        // Streak
                        formField(title: "Streak", text: $streak, placeholder: "Enter streak")
                        
                        // Target Date
                        formField(title: "Target Date", text: $targetDate, placeholder: "Enter target date")
                        
                        // Color Selection
                        colorSelection
                        
                        // Save Button
                        saveButton
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Edit Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadGoalData()
        }
    }
    
    // MARK: - Form Components
    
    private func formField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            TextField(placeholder, text: text)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                )
        }
    }
    
    private var progressSlider: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Progress: \(Int(progress * 100))%")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            Slider(value: $progress, in: 0...1)
                .accentColor(Color(selectedColor))
        }
    }
    
    private var colorSelection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Color")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(colors, id: \.self) { color in
                    Circle()
                        .fill(Color(color))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(selectedColor == color ? Color.primary : Color.clear, lineWidth: 3)
                        )
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveGoal) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Update Goal")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(saveButtonGradient)
            )
        }
    }
    
    // MARK: - Helper Functions
    
    private func loadGoalData() {
        title = goal.title ?? ""
        progress = goal.progress
        streak = goal.streak ?? ""
        targetDate = goal.targetDate ?? ""
        selectedColor = goal.color ?? "green"
    }
    
    private func saveGoal() {
        goal.title = title
        goal.progress = progress
        goal.streak = streak.isEmpty ? nil : streak
        goal.targetDate = targetDate
        goal.color = selectedColor
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Failed to update goal: \(error.localizedDescription)")
        }
    }
}

// Enhanced Color extension
extension Color {
    init(_ colorString: String) {
        switch colorString.lowercased() {
        case "green": self = .green
        case "orange": self = .orange
        case "blue": self = .blue
        case "purple": self = .purple
        case "red": self = .red
        case "pink": self = .pink
        case "cyan": self = .cyan
        case "yellow": self = .yellow
        default: self = .gray
        }
    }
}

#Preview {
    goalsPage()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
