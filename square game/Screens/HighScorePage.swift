//
//  HighScorePage.swift
//  square game
//
//  Created by Gayan 033 on 2025-01-11.
//

import SwiftUI

struct HighScorePage: View {
    // Retrieve the top 10 highest scores from UserDefaults
    let highScores: [Double] = UserDefaults.standard.array(forKey: "HighScores") as? [Double] ?? []

    var body: some View {
        VStack {
            // Title
            Text("HIGH SCORES")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 50)

            Spacer()

            // Display the top 10 high scores
            List {
                ForEach(highScores.indices, id: \.self) { index in
                    HStack {
                        Text("\(index + 1).")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        Spacer()
                        Text(String(format: "%.2f seconds", highScores[index]))
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("High Scores")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HighScorePage()
}
