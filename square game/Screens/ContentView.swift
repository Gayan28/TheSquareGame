import SwiftUI

struct ContentView: View {
    @State private var squares: [Color] = Array(repeating: .gray, count: 9)
    @State private var selectedIndices: [Int] = []
    @State private var points: Int = 0
    @State private var showFailureAlert: Bool = false
    @State private var buttonColors: [Color] = []
    @State private var isProcessing: Bool = false
    @State private var gameCompleted: Bool = false
    @State private var showColors: Bool = true
    @State private var countdown: Int = 3
    @State private var startTime: Date?
    @State private var elapsedTime: TimeInterval?
    @State private var highestScore: Double?

    init() {
        var baseColors: [Color] = [.red, .green, .blue, .yellow]
        baseColors += baseColors
        baseColors.append(.clear)
        baseColors.shuffle()
        _buttonColors = State(initialValue: baseColors)
    }

    var body: some View {
        VStack {
            // Title
            Text("Color Match Game")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // Points
            Text("Points: \(points)")
                .font(.title2)
                .padding(.bottom, 10)

            // Countdown
            if showColors {
                Text("Game starts in: \(countdown)")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding(.bottom, 20)
            }

            // Game Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                ForEach(0..<9, id: \.self) { index in
                    GameButton(color: squares[index]) {
                        handleSelection(index: index)
                    }
                    .disabled(isProcessing || squares[index] != .gray || gameCompleted || showColors)
                }
            }

            // Highest Score
            if let highestScore = highestScore {
                Text(String(format: "Highest Score: %.2f seconds", highestScore))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
            }

            // Restart Button
            Button("Restart Game") {
                restartGame()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .onAppear {
            startGame()
            fetchHighestScore()
        }
        .alert("No Color Matched!", isPresented: $showFailureAlert) {
            Button("OK", role: .cancel) { }
        }

        // Game Completion Overlay
        if gameCompleted {
            VStack {
                Text("Congratulations!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()

                Text("You've matched all the colors!")
                    .font(.headline)
                    .foregroundColor(.white)

                if let elapsedTime = elapsedTime {
                    Text(String(format: "Time: %.2f seconds", elapsedTime))
                        .font(.headline)
                        .foregroundColor(.white)
                }

                Button(action: restartGame) {
                    Text("Play Again")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.8))
            .edgesIgnoringSafeArea(.all)
            .transition(.opacity)
            .animation(.easeInOut, value: gameCompleted)
        }
    }

    // Starts the game and shows the countdown
    func startGame() {
        squares = buttonColors
        countdown = 3
        showColors = true
        startTime = nil

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
            } else {
                timer.invalidate()
                squares = Array(repeating: .gray, count: 9)
                showColors = false
                startTime = Date() // Start the timer
            }
        }
    }

    // Fetches the highest score from UserDefaults
    func fetchHighestScore() {
        let highScores = UserDefaults.standard.array(forKey: "HighScores") as? [Double] ?? []
        highestScore = highScores.first // Fetch the top score
    }

    // Handles button clicks during the game
    func handleSelection(index: Int) {
        guard squares[index] == .gray, buttonColors[index] != .clear else { return }

        squares[index] = buttonColors[index]
        selectedIndices.append(index)

        if selectedIndices.count == 2 {
            isProcessing = true
            let firstIndex = selectedIndices[0]
            let secondIndex = selectedIndices[1]

            if buttonColors[firstIndex] == buttonColors[secondIndex] {
                points += 1
                selectedIndices.removeAll()
                isProcessing = false

                // Check for game completion
                if points == 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        gameCompleted = true
                        elapsedTime = Date().timeIntervalSince(startTime ?? Date())
                        updateHighScores()
                        fetchHighestScore()
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    squares[firstIndex] = .gray
                    squares[secondIndex] = .gray
                    selectedIndices.removeAll()
                    isProcessing = false
                    showFailureAlert = true
                }
            }
        }
    }

    // Restarts the game
    func restartGame() {
        squares = Array(repeating: .gray, count: 9)
        buttonColors.shuffle()
        points = 0
        selectedIndices.removeAll()
        isProcessing = false
        gameCompleted = false
        startGame()
    }

    // Updates the high score list
    func updateHighScores() {
        guard let elapsedTime = elapsedTime else { return }

        var highScores = UserDefaults.standard.array(forKey: "HighScores") as? [Double] ?? []
        highScores.append(elapsedTime)
        highScores.sort()
        if highScores.count > 10 {
            highScores = Array(highScores.prefix(10)) // Keep only the top 10 scores
        }
        UserDefaults.standard.set(highScores, forKey: "HighScores")
    }
}

// A reusable game button component
struct GameButton: View {
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Rectangle()
                .fill(color)
                .frame(width: 100, height: 100)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }
}

#Preview {
    ContentView()
}
