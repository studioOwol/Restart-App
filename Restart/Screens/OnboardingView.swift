//
//  OnboardingView.swift
//  Restart
//
//  Created by Nahyun on 2023/04/17.
//

import SwiftUI

struct OnboardingView: View {
    //MARK: - Property
    
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffset: CGFloat = 0
    @State private var isAnimating: Bool = false
    @State private var imageOffset: CGSize = .zero
    @State private var indicatorOpacity: Double = 1.0
    @State private var textTitle: String = "Share."
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            Color("ColorBlue")
                .ignoresSafeArea(.all, edges: .all)
            
            VStack(spacing: 20) {
            //MARK: - Header
                
            Spacer()
            VStack(spacing:0){
                Text(textTitle)
                    .font(.system(size: 60))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .transition(.opacity)
                    .id(textTitle) // 뷰 재실행
                
                Text("""
                It's not how much we give but
                how much love weput into giving.
                """)
                .font(.title3)
                .fontWeight(.light)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
            } // Header Animation
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : -40 ) // 슬라이드 다운
            .animation(.easeOut(duration: 1), value: isAnimating)
                
            //MARK: - Center
            ZStack{
                CircleGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
                    .offset(x: imageOffset.width * -1)
                    .blur(radius: abs(imageOffset.width / 5))
                    .animation(.easeOut(duration: 1), value: imageOffset)
                
                Image("character-1")
                    .resizable()
                    .scaledToFit()
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeOut(duration: 0.5), value: isAnimating)
                    .offset(x: imageOffset.width * 1.2, y: 0)
                    .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                    .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                //abs함수 절대값 반환
                                if abs(imageOffset.width) <= 150{
                                    imageOffset = gesture.translation
                                    
                                    // 화살표 숨기기
                                    withAnimation(.linear(duration: 0.25)){
                                        indicatorOpacity = 0
                                        textTitle = "Give."
                                    }
                                }
                            }
                            .onEnded{ _ in
                                imageOffset = .zero
                                
                                // 화살표 다시 보이기
                                withAnimation(.linear(duration: 0.25)){
                                    indicatorOpacity = 1
                                    textTitle = "Share."
                                }
                            }
                    ) // Gesture
                    .animation(.easeOut(duration: 1), value: imageOffset)
            } //Center
            .overlay(
                Image(systemName: "arrow.left.and.right.circle")
                    .font(.system(size: 44, weight: .ultraLight))
                    .foregroundColor(.white)
                    .offset(y: 20)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeOut(duration: 1).delay(2), value: isAnimating)
                    .opacity(indicatorOpacity)
                , alignment: .bottom
            )
            Spacer()
            //MARK: - Footer
                ZStack{
                //Parts of the custom button
                //1. Background (Static)
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .padding(8)
                    
                //2. Call-to-Action (Static)
                    Text("Get Started")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20)
                    
                //3. Capsule (Dynamic Width)
                    HStack{
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + 80) // offset 초기값은 0, 드래그하는만큼 배경색이 따라오도록
                        Spacer()
                    }
                //4. Cirle (Draggable)
                    HStack {
                        ZStack{
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80, alignment: .center)
                        .offset(x: buttonOffset)
                        .gesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {
                                        buttonOffset = gesture.translation.width
                                    }
                                }
                                .onEnded { _ in
                                    // 홈 뷰로 매끄럽게 이동하는 애니메이션
                                    withAnimation(Animation.easeOut(duration: 0.4)){
                                        // 드래그가 절반 넘게 오른쪽으로 가까워지면 오른쪽으로 끌려감
                                        if buttonOffset > buttonWidth / 2 {
                                            hapticFeedback.notificationOccurred(.success)
                                            playSound(sound: "chimeup", type: "mp3")
                                            buttonOffset = buttonWidth - 80
                                            isOnboardingViewActive = false
                                        } else { // 드래그가 절반 이하로 움직이면 왼쪽으로 끌려감
                                            hapticFeedback.notificationOccurred(.warning)
                                            buttonOffset = 0
                                        }
                                    }
                                }
                        ) // Gesture
                        
                        Spacer()
                    }//HSTACK
                    
                }//Footer
                .frame(width: buttonWidth, height: 80, alignment: .center)
                .padding()
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.easeIn(duration: 1), value: isAnimating)
            }//:VSTACK
        }//:ZSTACK
        .onAppear(perform: {
            isAnimating = true
        })
        // 상태바 다크모드 디폴트
        .preferredColorScheme(.dark)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
