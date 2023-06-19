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
        NavigationView {
            ZStack {
                VStack {
                    List(0..<20) { index in
                        Text("Cell \(index)")
                            .onTapGesture {
                                selectedRow = index
                                showToast = true
                                print("selected row = \(selectedRow ?? 0)")
//                                Log.v("Tapped on listview cell \(index)")
//                                Log.i("Tapped on listview cell \(index)")
//                                Log.w("Tapped on listview cell \(index)")
//                                Log.e("Tapped on listview cell \(index)")
//                                Log.s("Tapped on listview cell \(index)")
//                                Log.d("Tapped on listview cell \(index)")
//                                AlpLog.shared.log(level: .debug, "Tapped on listview cell \(index)")
                                AlpLog.shared.log(level: .error, "Tapped on listview cell \(index)")
                            }
                    }
                }
                .overLaying(overlayView: NewToastView(show: $showToast, message: "Tapped On cell with index \(selectedRow ?? 0) dbvfhd dfv gdfgv fhdb jdsbfjdsbg jdfg jdfg jfdgv fdhv fdhg jfdg jfdg jdfbg dfbg jfdbg fdbgjfdb ghjbdf jghbhj"), show: $showToast)
//                .overlay(
//                    ToastView(isPresented: $showToast, duration: 2.0) {
//                        Text("Selected: \(selectedRow ?? 0)")
//                            .foregroundColor(.white)
//                    }
//                      )
            }
            .navigationTitle("List View")
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
