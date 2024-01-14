//
//  GameViewControllerRepresentable.swift
//  CourtJumpSlingshot
//
//  Created by Cipher Lunis on 1/13/24.
//

import Foundation
import SwiftUI

struct GameViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = GameViewController
    
    func makeUIViewController(context: Context) -> GameViewController {
        let vc = GameViewController()
        return vc
    }

    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}
