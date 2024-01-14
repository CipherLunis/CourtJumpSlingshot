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
    //@StateObject var gameScene = GameScene(size: UIScreen.main.bounds.size)
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                GameViewControllerRepresentable()
                //SpriteKitContainer(scene: SKScene(fileNamed: "GameScene")!)
                //SpriteKitContainer(scene: GameScene(size: UIScreen.main.bounds.size))
                    .ignoresSafeArea()
                    //.aspectRatio(contentMode: .fit)
                // shadow opacity
//                Rectangle()
//                    .fill(.black)
//                    .ignoresSafeArea()
//                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//                    .opacity(gameScene.isGameOver ? 0.5 : 0.0)
//                GameOverView(score: gameScene.points,
//                             playAgain: {
//                                gameScene.initializeGame()
//                            }, backToStart: {
//                                didStartGame = false
//                            })
//                    .offset(y: gameScene.isGameOver ? 0.0 : geo.size.height)
//                    .animation(.interpolatingSpring(mass: 0.01, stiffness: 1, damping: 0.5, initialVelocity: 5.0), value: gameScene.isGameOver)
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
