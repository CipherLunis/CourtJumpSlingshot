//
//  StartScreenButton.swift
//  CourtJumpSlingshot
//
//  Created by Cipher Lunis on 1/13/24.
//

import SwiftUI

struct StartScreenButton: View {
    var text: String
    var width: CGFloat
    var height: CGFloat
    var isIPad: Bool
    var startGame: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                startGame()
            } label: {
                Text(text)
                    .foregroundColor(.white)
                    .font(.system(size: isIPad ? 60 : 40))
                    .frame(width: width)
            }
            .frame(width: width, height: height)
            .background(.green)
            .cornerRadius(10)
            Spacer()
        }
    }
}

struct StartScreenButton_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            StartScreenButton(text: "Start!", width: geo.size.width/3.5, height: geo.size.height/6, isIPad: false) {}
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
