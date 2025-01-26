//
//  HomePage.swift
//  square game
//
//  Created by Gayan 033 on 2025-01-11.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea() // Ensure the gradient covers the whole screen

                VStack(spacing: 20) {
                    Text("Colour Matching Game")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white) // Ensure text is visible on gradient
                        .padding(.bottom, 50)

                    NavigationLink(destination: ContentView()) {
                        Text("Start Game")
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: HighScorePage()) {
                        Text("Highest Scores")
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: GuidePage()) {
                        Text("Guide")
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        exitGame()
                    }) {
                        Text("Exit")
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
    }

    func exitGame() {
        exit(0) // Forcefully exits the app
    }
}

#Preview {
    HomePage()
}
