//
//  SwiftUIView.swift
//  
//
//  Created by Alphonsa Varghese on 19/06/23.
//

import SwiftUI

struct NewToastView: View {
    
    @Binding var show: Bool
    let message: String
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(message)
            }
            .font(.headline)
            .foregroundColor(.primary)
            .padding(.vertical, 20)
            .padding(.horizontal, 40)
            .background(.gray.opacity(0.4), in: Capsule())
        }
        .frame(width: UIScreen.main.bounds.width)
        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.show.toggle()
                }
            }
        }
    }
}


struct OverLay<T: View>: ViewModifier {
    @Binding var show: Bool
    let overlayView: T
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                overlayView
            }
        }
    }
}


extension View {
    func overLay<T: View>(overlayView: T, show: Binding<Bool>) -> some View {
        self.modifier(OverLay(show: show, overlayView: overlayView))
    }
}