//
//  SwiftUIView.swift
//  
//
//  Created by Alphonsa Varghese on 14/06/23.
//

import SwiftUI

public struct SwiftUIView: View {
    var str = ""
    public init(str: String? = nil) {
        self.str = str ?? "No value"
    }
  public var body: some View {
        Text(str)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
