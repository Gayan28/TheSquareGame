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
    @State private var showAlert: Bool = false
    @State private var buttonColors: [Color] = []
    @State private var isProcessing: Bool = false
    @State private var gameCompleted: Bool = false
    @State private var showCountdown: Bool = true
    @State private var countdown: Int = 3

    init() {
        var baseColors: [Color] = [.red, .green, .blue, .orange]
        baseColors += baseColors
        baseColors.append(.clear)
        baseColors.shuffle()
        _buttonColors = State(initialValue: baseColors)
    }

    var body: some View {
        ZStack {
            if showCountdown {
                VStack {
                    Text("Game Starts In \(countdown)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                        .padding()
                    .onAppear(perform: startCountdown)
                }
            } else {
                VStack {
                    Text("Color Match Game")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 50)

                    Text("Points: \(points)")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(Color.black)
                        .lineLimit(nil)
                        .frame(width: 100.0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 70)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                        ForEach(0..<9, id: \.self) { index in
                            Button(action: {
                                handleSelection(index: index)
                            }) {
                                Rectangle()
                                    .fill(squares[index])
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .padding(.all, 10)
                            }
                            .disabled(isProcessing || squares[index] != .gray || gameCompleted)
                        }
                    }

                    Button("Restart Game") {
                        restartGame()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                }
                .padding()
                .alert(gameCompleted ? "You Have Won!" : "Try Again", isPresented: $showAlert) {
                    Button(gameCompleted ? "Play Again" : "OK", role: .cancel) {
                        if gameCompleted {
                            restartGame()
                        }
                    }
                }
            }
        }
    }

    func startCountdown() {
        for second in (0..<countdown).reversed() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(countdown - second)) {
                countdown = second
                if second == 0 {
                    showCountdown = false
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(countdown)) {
            startGame()
        }
    }
    
    func startGame() {
        squares = Array(repeating: .gray, count: 9)
        points = 0
        selectedIndices.removeAll()
        isProcessing = false
        gameCompleted = false
        buttonColors.shuffle()
    }

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

                if squares.allSatisfy({ $0 != .gray }) {
                    gameCompleted = true
                    showAlert = true
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    squares[firstIndex] = .gray
                    squares[secondIndex] = .gray
                    showAlert = true
                    selectedIndices.removeAll()
                    isProcessing = false
                }
            }
        }
    }
    
    func restartGame() {
        squares = Array(repeating: .gray, count: 9)
        points = 0
        selectedIndices.removeAll()
        isProcessing = false
        gameCompleted = false
        showCountdown = true
        countdown = 5
        buttonColors.shuffle()
    }
}

#Preview {
    ContentView()
}
