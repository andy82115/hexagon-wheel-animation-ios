//
//  ContentView.swift
//  AndyHexagonWheel
//
//  Created by Andy Yeh on 2024/9/10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HexagonBtn(color: .blue, index: <#Int#>) {_ in 
                print("Hexagon button tapped!")
            }
            .frame(width: 200, height: 200)
        }
    }
}

#Preview {
    ContentView()
}
