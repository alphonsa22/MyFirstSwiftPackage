//
//  File.swift
//  
//
//  Created by Alphonsa Varghese on 16/06/23.
//

import Foundation
import SwiftUI

public struct ToastView<Content: View>: View {
    @Binding public var isPresented: Bool
  public let content: () -> Content
    public init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self._isPresented = isPresented
        self.content = content
    }
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
//                    Spacer()
                    if isPresented {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.black.opacity(0.7))
                            .frame(width: 200, height: 100)
                            .overlay(content())
                            .transition(.opacity)
                            .onTapGesture {
                                withAnimation {
                                    isPresented = false
                                }
                            }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
            }
        }
    }
}
