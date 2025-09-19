//
//  habitsPage.swift
//  Journal
//
//  Created by Proushoth Koushal on 8/19/25.
//

import SwiftUI
import CoreData
import UserNotifications

struct habitsPage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var notificationManager = NotificationManager.shared
    @State private var newHabitName = ""
    @State private var showingAddHabit = false
    @State private var selectedDate = Date()
    @State private var showingPermissionAlert = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.dateCreated, ascending: true)],
        animation: .default
    )
    private var habits: FetchedResults<Habit>
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                   
                    headerCard
                    
                  
                    dateSelector
                    
                    
                    progressSection
                    
             
                    habitsGrid
                    
                   
                    addHabitButton
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.systemGray6).opacity(0.3)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("My Habits")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingAddHabit) {
                addHabitSheet
            }
            .alert("Enable Notifications", isPresented: $showingPermissionAlert) {
                Button("Settings") {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
                Button("Later", role: .cancel) {}
            } message: {
                Text("Enable notifications to get reminders about your habits and celebrate your progress!")
            }
            .onAppear {
                requestNotificationPermissionIfNeeded()
            }
        }
    }
    
    
    private var headerCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Keep Going!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Build consistency one day at a time")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.orange)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(.orange.opacity(0.1))
                    )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
        )
    }
    
  
    private var dateSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Date")
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(dateRange(), id: \.self) { date in
                        DateCard(
                            date: date,
                            isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                            isToday: Calendar.current.isDateInToday(date)
                        ) {
                            selectedDate = date
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    

    private var progressSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Today's Progress")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(completedCount)/\(habits.count)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
            }
            
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 8)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: progressPercentage)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1), value: progressPercentage)
                
                VStack(spacing: 4) {
                    Text("\(Int(progressPercentage * 100))%")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Complete")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
        )
    }
    

    private var habitsGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Habits")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(habits) { habit in
                    HabitCard(habit: habit) {
                        withAnimation(.spring(response: 0.3)) {
                            toggleHabit(habit)
                        }
                    }
                }
                .onDelete(perform: deleteHabits)
            }
        }
    }
    

    private var addHabitButton: some View {
        Button(action: { showingAddHabit = true }) {
            HStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                
                Text("Add New Habit")
                    .font(.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
    
 
    private var addHabitSheet: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.accentColor)
                    
                    Text("Create New Habit")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Start building a better you")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Habit Name")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TextField("e.g., Drink 8 glasses of water", text: $newHabitName)
                        .textFieldStyle(.plain)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                        .onSubmit {
                            if !newHabitName.isEmpty {
                                addHabit()
                            }
                        }
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: addHabit) {
                        Text("Create Habit")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(newHabitName.isEmpty ? .gray : .accentColor)
                            )
                    }
                    .disabled(newHabitName.isEmpty)
                    
                    Button("Cancel") {
                        showingAddHabit = false
                        newHabitName = ""
                    }
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 34)
            .navigationBarHidden(true)
        }
        .presentationDetents([.fraction(0.5)])
        .presentationDragIndicator(.visible)
    }
    
    
    private var completedCount: Int {
        habits.filter { $0.isCompleted }.count
    }
    
    private var progressPercentage: Double {
        guard !habits.isEmpty else { return 0 }
        return Double(completedCount) / Double(habits.count)
    }
    
    private func dateRange() -> [Date] {
        let calendar = Calendar.current
        var dates: [Date] = []
        for i in -3...3 {
            if let date = calendar.date(byAdding: .day, value: i, to: Date()) {
                dates.append(date)
            }
        }
        return dates
    }
    
    private func requestNotificationPermissionIfNeeded() {
        notificationManager.checkPermissionStatus { isAuthorized in
            if !isAuthorized {
                showingPermissionAlert = true
            }
        }
    }
    
    private func addHabit() {
        let trimmed = newHabitName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let habitId = UUID()
        let newHabit = Habit(context: viewContext)
        newHabit.id = habitId
        newHabit.name = trimmed
        newHabit.isCompleted = false
        newHabit.streak = 0
        newHabit.dateCreated = Date()
        newHabit.lastCompletedDate = nil
        
        saveContext()
        
     
        notificationManager.scheduleHabitNotification(for: trimmed, habitId: habitId)
      
        
        newHabitName = ""
        showingAddHabit = false
    }
    
    private func toggleHabit(_ habit: Habit) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if habit.isCompleted {
        
            habit.isCompleted = false
        } else {
         
            habit.isCompleted = true
            
            if let lastDate = habit.lastCompletedDate {
                if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
                   calendar.isDate(lastDate, inSameDayAs: yesterday) {
                    habit.streak += 1
                } else if !calendar.isDate(lastDate, inSameDayAs: today) {
                    habit.streak = 1
                }
            } else {
                habit.streak = 1
            }
            
            habit.lastCompletedDate = today
        }
        
        saveContext()
    }
    
    private func deleteHabits(offsets: IndexSet) {
        withAnimation {
            offsets.map { habits[$0] }.forEach { habit in
               
                if let habitId = habit.id {
                    notificationManager.removeNotifications(for: habitId)
                }
                viewContext.delete(habit)
            }
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}


struct DateCard: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let action: () -> Void
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }
    
    private var numberFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(dayFormatter.string(from: date))
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .secondary)
                
                Text(numberFormatter.string(from: date))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(isSelected ? .white : .primary)
                
                if isToday && !isSelected {
                    Circle()
                        .fill(.orange)
                        .frame(width: 4, height: 4)
                } else {
                    Circle()
                        .fill(.clear)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(width: 60, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .accentColor : Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HabitCard: View {
    @ObservedObject var habit: Habit
    let toggleAction: () -> Void
    
    var body: some View {
        Button(action: toggleAction) {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(habit.isCompleted ? .green : .gray)
                    
                    Spacer()
                    
                    if habit.streak > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .font(.caption)
                            Text("\(habit.streak)")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule().fill(.orange.opacity(0.1))
                        )
                    }
                }
                
                Text(habit.name ?? "")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.primary)
                    .strikethrough(habit.isCompleted, color: .secondary)
                
                Spacer()
            }
            .padding(16)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
            .scaleEffect(habit.isCompleted ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: habit.isCompleted)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    return habitsPage()
        .environment(\.managedObjectContext, context)
}
