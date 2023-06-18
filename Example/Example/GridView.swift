//
//  GridView.swift
//  Example
//
//  Created by Alphonsa Varghese on 18/06/23.
//

import Foundation
import SwiftUI

struct GridView: View {
    let gridItems = Array(repeating: GridItem(.fixed(30), spacing: 0), count: 24)
    let labels = (1...24).map { "\($0)" }
    
    var body: some View {
//        ScrollView(.horizontal) {
        List(0..<20) { index in
            ScrollView(.horizontal,showsIndicators: false) {
                LazyVGrid(columns: gridItems, spacing: 0) {
                    ForEach(0..<24) { index in
                        VStack {
                            Rectangle()
                                .foregroundColor(index >= 4 && index <= 8 ? .green : .white)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(Color.gray, lineWidth: 0.5)
//                                        .padding(.top, -2)
                                )
                            Text(labels[index])
                                .font(.system(size: 12))
                                .multilineTextAlignment(.trailing)
                                .padding(2)

                        }
                    }
                }
            }
            //            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}
