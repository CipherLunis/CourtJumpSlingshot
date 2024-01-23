//
//  AfterLevelView.swift
//  CourtJumpSlingshot
//
//  Created by Cipher Lunis on 1/21/24.
//

import SwiftUI

struct AfterLevelView: View {
    let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        
    var score: Int
    @Binding var levelNumber: Int
    var playAgain: () -> Void
    var backToStart: () -> Void
    
    var body: some View {
        GeometryReader { geo in
                    ZStack {
                        VStack {
                            Spacer()
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Text("Score:")
                                        .foregroundColor(.black)
                                        .font(.system(size: isIPad ? 70 : 50))
                                        .fontWeight(.semibold)
                                    Text("\(score)")
                                        .foregroundColor(.black)
                                        .font(.system(size: isIPad ? 70 : 50))
                                }
                                HStack {
                                    Text("Level:")
                                        .foregroundColor(.black)
                                        .font(.system(size: isIPad ? 70 : 50))
                                        .fontWeight(.semibold)
                                    Text("\(levelNumber)")
                                        .foregroundColor(.black)
                                        .font(.system(size: isIPad ? 70 : 50))
                                }
                            }
                            Spacer()
                            if levelNumber < 2 {
                                AfterLevelButton(isIPad: isIPad, text: "NEXT", size: CGSizeMake(geo.size.width/5, geo.size.height/6)) {
                                    playAgain()
                                }
                            } else {
                                AfterLevelButton(isIPad: isIPad, text: "HOME", size: CGSizeMake(geo.size.width/5, geo.size.height/6)) {
                                    backToStart()
                                }
                            }
                        }
                        .frame(width: geo.size.width/2, height: geo.size.height/1.7)
                        .padding(.bottom, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 20.0)
                                .fill(Color(#colorLiteral(red: 244/255, green: 228/255, blue: 140/255, alpha: 1.0)))
                                .shadow(radius: 20.0)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .ignoresSafeArea()
    }
}

struct AfterLevelView_Previews: PreviewProvider {
    static var previews: some View {
        AfterLevelView(score: 0856876, levelNumber: .constant(1), playAgain: {}, backToStart: {})
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
