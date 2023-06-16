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
  public let content: () -> Content
    
 public var body: some View {
        Group {
            if isPresented {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.black.opacity(0.7))
                        .frame(width: 200, height: 100)
                        .overlay(content())
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3)) {
                isPresented = true
            }
        }
        .onDisappear {
            withAnimation(.easeInOut(duration: 0.3)) {
                isPresented = false
            }
        }
    }
}
