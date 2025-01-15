//
//  ContentView.swift
//  square game
//
//  Created by Gayan 033 on 2025-01-05.
//

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
        .onAppear(perform: startGame)
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

                Button(action: restartGame) {
                    Text("Play Again")
                        .padding()
                        .background(Color.green)
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
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
            } else {
                timer.invalidate()
                squares = Array(repeating: .gray, count: 9)
                showColors = false
            }
        }
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
                        updateHighScore()
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

    // Updates the high score
    func updateHighScore() {
        let currentHighScore = UserDefaults.standard.integer(forKey: "HighScore")
        if points > currentHighScore {
            UserDefaults.standard.set(points, forKey: "HighScore")
        }
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
