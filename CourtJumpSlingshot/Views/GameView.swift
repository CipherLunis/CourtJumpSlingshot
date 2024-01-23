//
//  GameView.swift
//  CourtJumpSlingshot
//
//  Created by Cipher Lunis on 1/13/24.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @Binding var didStartGame: Bool
    //@State var yOffset = UIScreen.main.bounds.height
    @StateObject var gameViewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                GameViewControllerRepresentable()
                    .ignoresSafeArea()
                    .environmentObject(gameViewModel)
                    .id(gameViewModel.levelNumber)
                // shadow opacity
                Rectangle()
                    .fill(.black)
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .opacity(gameViewModel.didBeatLevel ? 0.5 : 0.0)
                AfterLevelView(
                    score: gameViewModel.score,
                    levelNumber: gameViewModel.levelNumber,
                    playAgain: {
                        gameViewModel.levelNumber += 1
                        gameViewModel.didBeatLevel = false
                    },
                    backToStart: {
                        didStartGame = false
                    }
                )
                .offset(y: gameViewModel.didBeatLevel ? 0.0 : geo.size.height)
                //.offset(y: yOffset)
//                .onChange(of: gameViewModel.didBeatLevel) { newValue in
//                    if newValue {
//                        withAnimation {
//                            //geo.size.height
//                            yOffset = 0
//                        }
//
//                        // Add a delay to execute code after animation is complete
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            gameViewModel.score = 200
//                            // Code to run after animation is complete
//                            print("Animation completed!")
//                        }
//                    }
//                }
                .animation(.interpolatingSpring(mass: 0.01, stiffness: 1, damping: 0.5, initialVelocity: 5.0), value: gameViewModel.didBeatLevel)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(didStartGame: .constant(true))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
