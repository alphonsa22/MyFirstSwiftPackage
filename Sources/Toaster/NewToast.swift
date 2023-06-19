//
//  SwiftUIView.swift
//  
//
//  Created by Alphonsa Varghese on 19/06/23.
//

import SwiftUI

public struct NewToastView: View {
    
    @Binding var show: Bool
    let message: String
    
    public init (show: Binding<Bool>, message: String) {
        self._show = show
        self.message = message
    }
   public var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(message)
                    .padding()
            }
            .font(.headline)
            .foregroundColor(.primary)
//            .padding(.vertical, 20)
//            .padding(.horizontal, 40)
            .background(.gray)
            .padding()
            .frame(width: UIScreen.main.bounds.width)
        }
//        .frame(width: UIScreen.main.bounds.width)
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


public struct OverLay<T: View>: ViewModifier {
    @Binding var show: Bool
    let overlayView: T
    
   public func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                overlayView
            }
        }
    }
}


extension View {
  public func overLaying<T: View>(overlayView: T, show: Binding<Bool>) -> some View {
        self.modifier(OverLay(show: show, overlayView: overlayView))
    }
}
