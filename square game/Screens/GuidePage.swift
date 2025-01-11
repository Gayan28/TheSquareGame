//
//  GuidePage.swift
//  square game
//
//  Created by Gayan 033 on 2025-01-11.
//

import SwiftUI

// High Score Page
struct GuidePage: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Game Guidelines")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Text("1. Objective:")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("   Match pairs of colored squares to score points.")

                Text("2. Game Setup:")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("   - The game consists of 9 squares, hidden initially.")
                Text("   - A random selection of colors will be placed behind the squares.")

                Text("3. Gameplay:")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("   - Tap two squares to reveal their colors.")
                Text("   - If they match, you score a point.")
                Text("   - If they don't match, the squares will hide again.")
                Text("   - Continue until all pairs are matched.")

                Text("4. Scoring:")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("   - You earn 1 point for each matched pair.")
                Text("   - The game ends when all pairs are matched.")

                Text("5. Restarting the Game:")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("   - You can restart the game at any time by pressing the restart button.")
                
                Text("Enjoy the game and have fun!")
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Guidelines")
        .navigationBarTitleDisplayMode(.inline)
    }
}
