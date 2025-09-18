import SwiftUI
import CoreML

struct MoodTrend: View {
    @State private var shortResponse = ""
    @State private var longResponse = ""
    @State private var animateElements = false
    @State private var isAnalyzing = false
    @State private var mlModel: iosAssignment?
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.05), Color.clear],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var titleGradient: LinearGradient {
        LinearGradient(colors: [.primary, .secondary], startPoint: .leading, endPoint: .trailing)
    }
    
    private var buttonGradient: LinearGradient {
        LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    shortTextInput
                    submitButton
                    longTextArea
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
        .onAppear {
            loadMLModel()
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateElements = true
            }
        }
    }
    
    private var headerSection: some View {
        Text("How are you feeling today ?")
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundStyle(titleGradient)
            .opacity(animateElements ? 1 : 0)
            .offset(y: animateElements ? 0 : -20)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateElements)
    }
    
    private var shortTextInput: some View {
        TextField("Enter your feelings here...", text: $shortResponse)
            .textFieldStyle(PlainTextFieldStyle())
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 25).fill(.ultraThinMaterial))
            .opacity(animateElements ? 1 : 0)
            .offset(y: animateElements ? 0 : 20)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateElements)
    }
    
    private var submitButton: some View {
        HStack {
            Spacer()
            Button(action: {
                analyzeMood(text: shortResponse)
            }) {
                HStack(spacing: 8) {
                    if isAnalyzing {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                    Text(isAnalyzing ? "Analyzing..." : "Analyze Mood")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(RoundedRectangle(cornerRadius: 25).fill(buttonGradient).opacity(shortResponse.isEmpty ? 0.6 : 1))
            }
            .disabled(shortResponse.isEmpty || isAnalyzing)
            Spacer()
        }
    }
    
    private var longTextArea: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
                .frame(minHeight: 300)
            
            if longResponse.isEmpty && !isAnalyzing {
                Text("Analysis results will appear here...")
                    .foregroundColor(.secondary)
                    .padding(20)
            }
            
            ScrollView {
                Text(longResponse)
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .font(.system(size: 16, design: .rounded))
            }
            .frame(minHeight: 300)
        }
        .opacity(animateElements ? 1 : 0)
        .offset(y: animateElements ? 0 : 30)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateElements)
    }
    
    private func loadMLModel() {
        do {
            mlModel = try iosAssignment(configuration: MLModelConfiguration())
        } catch {
            print("Failed to load ML model: \(error)")
            longResponse = "Error: Could not load the mood analysis model."
        }
    }
    
    private func analyzeMood(text: String) {
        guard let model = mlModel, !text.isEmpty else {
            longResponse = "Error: Model not available or text is empty."
            return
        }
        
        isAnalyzing = true
        longResponse = ""
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let prediction = try model.prediction(input: iosAssignmentInput(text: text))
                DispatchQueue.main.async {
                    self.isAnalyzing = false
                    self.longResponse = formatPredictionResult(prediction)
                }
            } catch {
                DispatchQueue.main.async {
                    self.isAnalyzing = false
                    self.longResponse = "Error analyzing mood: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func formatPredictionResult(_ prediction: iosAssignmentOutput) -> String {
        let label = prediction.label
        let emoji = getMoodEmoji(for: label)
        return """
        🎭 Mood Analysis Result

        📊 Predicted Mood: \(label.capitalized) \(emoji)

        💡 Remember: This is an AI suggestion. Trust your feelings!
        """
    }
    
    private func getMoodEmoji(for mood: String) -> String {
        switch mood.lowercased() {
        case "happy", "joy", "positive": return "😊"
        case "sad", "sadness": return "😢"
        case "angry", "anger": return "😠"
        case "fear", "afraid": return "😰"
        case "surprise", "surprised": return "😲"
        case "disgust": return "🤢"
        case "neutral": return "😐"
        case "love": return "❤️"
        case "excited": return "🤩"
        case "anxious", "anxiety": return "😟"
        default: return "🎭"
        }
    }
}

#Preview {
    MoodTrend()
}
