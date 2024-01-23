//
//  GameViewModel.swift
//  CourtJumpSlingshot
//
//  Created by Cipher Lunis on 1/18/24.
//

import Foundation

class GameViewModel: ObservableObject {
    @Published var didBeatLevel = false
    @Published var levelNumber = 1
    @Published var score = 0
}
