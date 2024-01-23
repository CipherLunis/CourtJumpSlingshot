//
//  StartView.swift
//  CourtJumpSlingshot
//
//  Created by Cipher Lunis on 1/13/24.
//

import SwiftUI

struct StartView: View {
    let isIPad = UIDevice.current.userInterfaceIdiom == .pad
    
    @State var didStartGame = false
    
    var body: some View {
        ZStack {
            if !didStartGame {
                GeometryReader { geo in
                    Image("BG")
                        .resizable()
                    VStack {
                        Text("Court Jump Slingshot!")
                            .font(.system(size: isIPad ? 80 : 60))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(width: geo.size.width/2)
                            .cornerRadius(20)
                            .padding(.top)
                        Spacer()
                        Image("Ground")
                            .resizable()
                            .frame(width: geo.size.width, height: geo.size.height/6)
                    }
                    VStack {
                        Spacer()
                        StartScreenButton(text: "Start!", width: geo.size.width/3.5, height: geo.size.height/6, isIPad: isIPad) {
                            didStartGame = true
                        }
                        .padding(.bottom, geo.size.height/12)
                        .shadow(radius: 10.0)
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image("Slingshot")
                                .resizable()
                                .frame(width: geo.size.width/10, height: geo.size.height/2)
                            Spacer()
                                .frame(width: geo.size.width/7)
                        }
                        Spacer()
                            .frame(height: geo.size.height/7)
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image("Jump1")
                                .resizable()
                                .renderingMode(.original)
                                .colorMultiply(.red)
                                .frame(width: geo.size.width/7, height: geo.size.height/2)
                                .rotationEffect(Angle(degrees: 320))
                            Spacer()
                                .frame(width: geo.size.width/6)
                        }
                        Spacer()
                            .frame(height: geo.size.height/4)
                    }
                }
                .ignoresSafeArea()
            } else {
                GameView(didStartGame: $didStartGame)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.35)))
            }
        }
    }
}

//
//  StartView.swift
//  MyMangoIsToBlowUp
//
//  Created by Cipher Lunis on 1/6/24.
//
//
//import SwiftUI
//
//struct StartView: View {
//    let isIPad = UIDevice.current.userInterfaceIdiom == .pad
//
//    @State var didStartGame = false
//
//    var body: some View {
//        ZStack {
//            if !didStartGame {
//                GeometryReader { geo in
//                    Image(K.Images.MangoFarmBG)
//                        .resizable()
//                        .ignoresSafeArea()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .topLeading)
//                    VStack {
//                        Spacer()
//                        HStack {
//                            Image(K.Images.Chomp1)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: geo.size.width/4)
//                                .rotationEffect(Angle(degrees: -25))
//                            Spacer()
//                            Image(K.Images.Chomp1)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: geo.size.width/4)
//                                .rotationEffect(Angle(degrees: 25))
//                        }
//                        Spacer()
//                    }
//                    HStack {
//                        Spacer()
//                        HStack {
//                            Text("My Mango Is To Blow Up!")
//                                .font(.system(size: isIPad ? 80 : 60))
//                                .multilineTextAlignment(.center)
//                                .lineLimit(2)
//                                .fontWeight(.semibold)
//                                .foregroundColor(.white)
//                                .frame(width: geo.size.width/2)
//                                .background(.green)
//                                .cornerRadius(20)
//                        }
//                        Spacer()
//                    }
//                    .padding(.top, 20)
//                    VStack {
//                        Spacer()
//                        StartScreenButton(text: "Start!", width: geo.size.width/3.5, height: geo.size.height/6, isIPad: isIPad) {
//                            didStartGame = true
//                        }
//                        .padding(.bottom)
//                    }
//                }
//            } else {
//                GameView(didStartGame: $didStartGame)
//                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.35)))
//            }
//        }
//    }
//}

//struct StartView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartView()
//            .previewInterfaceOrientation(.landscapeLeft)
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
