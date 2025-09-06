import SwiftUI

struct JournalEntry: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
    let mood: String
    let content: String
}

struct journalPage: View {
    @State private var journalEntries: [JournalEntry] = []
    @State private var showAddJournal = false
    @State private var newJournalTitle = ""
    @State private var newJournalMood = ""
    @State private var newJournalContent = ""

    let moods = ["😊 Happy", "😔 Sad", "😡 Angry", "😌 Calm", "😕 Confused", "😎 Confident"]

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Button(action: {
                    showAddJournal = true
                }) {
                    Label("Add Journal", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
                .padding(.top)

                if journalEntries.isEmpty {
                    Spacer()
                    VStack {
                        Image(systemName: "book.closed")
                            .font(.system(size: 48))
                            .foregroundColor(.gray.opacity(0.5))
                        Text("No journals yet")
                            .foregroundColor(.gray)
                            .font(.title3)
                    }
                    Spacer()
                } else {
                    List(journalEntries.sorted { $0.date > $1.date }) { entry in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(entry.title)
                                    .font(.headline)
                                Spacer()
                                Text(entry.mood)
                                    .font(.subheadline)
                                    .padding(6)
                                    .background(Color.gray.opacity(0.15))
                                    .cornerRadius(8)
                            }
                            Text(entry.content)
                                .font(.body)
                                .foregroundColor(.primary)
                            HStack {
                                Spacer()
                                Text(entry.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .padding(.horizontal)
            .navigationTitle("Journal")
            .sheet(isPresented: $showAddJournal) {
                VStack(spacing: 20) {
                    Text("New Journal Entry")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)

                    TextField("Title", text: $newJournalTitle)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )

                    Picker("Mood", selection: $newJournalMood) {
                        ForEach(moods, id: \.self) { mood in
                            Text(mood)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    TextEditor(text: $newJournalContent)
                        .frame(height: 120)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                        )

                    Button(action: {
                        let newEntry = JournalEntry(
                            date: Date(),
                            title: newJournalTitle,
                            mood: newJournalMood,
                            content: newJournalContent
                        )
                        journalEntries.append(newEntry)
                        newJournalTitle = ""
                        newJournalMood = ""
                        newJournalContent = ""
                        showAddJournal = false
                    }) {
                        Text("Save")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background((newJournalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || newJournalMood.isEmpty || newJournalContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(newJournalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || newJournalMood.isEmpty || newJournalContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    journalPage()
}
