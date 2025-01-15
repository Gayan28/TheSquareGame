//
//  HighScorePage.swift
//  square game
//
//  Created by Gayan 033 on 2025-01-11.
//

import SwiftUI

struct HighScorePage: View {
    // Retrieve the highest score from UserDefaults
    let highScore = UserDefaults.standard.integer(forKey: "HighScore")

    var body: some View {
        VStack {
            // Title
            Text("HIGH SCORE")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 50)

            Spacer()

            // Display the high score
            Text("Your Highest Score is: \(highScore)")
                .font(.title)
                .foregroundColor(.blue)

            Spacer()
        }
        .padding()
        .navigationTitle("High Score")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HighScorePage()
}
