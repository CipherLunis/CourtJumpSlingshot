//
//  AfterLevelButton.swift
//  CourtJumpSlingshot
//
//  Created by Cipher Lunis on 1/22/24.
//

import SwiftUI

struct AfterLevelButton: View {
    var isIPad: Bool
    var text: String
    var size: CGSize
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .foregroundColor(.black)
                .font(.system(size: isIPad ? 50 : 30))
                .fontWeight(.semibold)
        }
        .frame(width: size.width, height: size.height)
        .background {
            LinearGradient(stops: [
                .init(color: .blue, location: 0),
                .init(color: .white, location: 2.5)
            ], startPoint: .top, endPoint: .bottom)
        }
        .cornerRadius(20.0)
        .shadow(radius: 5.0)
    }
}

struct AfterLevelButton_Previews: PreviewProvider {
    static var previews: some View {
        AfterLevelButton(isIPad: false, text: "TEXT", size: CGSize(width: 200, height: 100), action: {})
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
