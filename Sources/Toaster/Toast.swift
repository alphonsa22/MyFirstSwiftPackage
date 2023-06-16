//
//  File.swift
//  
//
//  Created by Alphonsa Varghese on 16/06/23.
//

import Foundation
import SwiftUI

public struct ToastView<Content: View>: View {
    @Binding var isPresented: Bool
     let content: () -> Content
     let duration: TimeInterval
     
     public init(isPresented: Binding<Bool>, duration: TimeInterval, @ViewBuilder content: @escaping () -> Content) {
         self._isPresented = isPresented
         self.duration = duration
         self.content = content
     }
     
     public var body: some View {
         GeometryReader { geometry in
             ZStack {
                 VStack {
//                     Spacer()
                     if isPresented {
                         RoundedRectangle(cornerRadius: 10)
                             .foregroundColor(Color.black.opacity(0.7))
                             .frame(width: 200, height: 50)
                             .overlay(content())
                             .transition(.opacity)
                             .onAppear {
                                 startTimer()
                             }
                     }
                 }
                 .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                 Spacer()
             }
         }
     }
     
     private func startTimer() {
         DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
             dismissToast()
         }
     }
     
     private func dismissToast() {
         withAnimation {
             isPresented = false
         }
     }
}
