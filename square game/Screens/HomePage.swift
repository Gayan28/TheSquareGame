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
            VStack(spacing: 20) {
                Text("Colour Matching Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 50)

                NavigationLink(destination: ContentView()) {
                    Text("Start Game")
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: HighScorePage()) {
                    Text("High Scores")
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: GuidePage()){
                    Text("Guide")
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    // Action for Button 4
                }) {
                    Text("Exit")
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

// Your ContentView can stay as is, just make sure to call HomePage initially in your App struct or Scene.
