//
//  ContentView.swift
//  Example
//
//  Created by Alphonsa Varghese on 15/06/23.
//

import SwiftUI
import MyFirstSwiftPackage

struct ContentView: View {
    @State private var showToast = false
    @State private var selectedRow: Int?
    var body: some View {
//        VStack {
////            SwiftUIView(str:"Package Testing....")
//            Button {
//                Log.d("debug testing")
//                showToast.toggle()
//            } label: {
//                Text("Click to log")
//            }
//            .padding()
//            ToastView(isPresented: $showToast, duration: 2.0) {
//                           Text("Toast Message")
//                               .foregroundColor(.white)
//                       }
//        }
        NavigationView {
            ZStack {
                VStack {
                    List(0..<20) { index in
                               Text("Cell \(index)")
                                   .onTapGesture {
                                       showToast = true
                                       selectedRow = index
                                      }
                           }
//                    .padding()
                    
                    ToastView(isPresented: $showToast, duration: 2.0) {
                                   Text("selected row is \(selectedRow ?? 0)")
                                       .foregroundColor(.white)
                               }
                    .background(Color.pink)
                }
                .navigationTitle("List View")
            }
               }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
