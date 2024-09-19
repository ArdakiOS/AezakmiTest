//
//  LoadingView.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 17.09.2024.
//

import SwiftUI

struct LoadingView: View {
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var rot = 0.0
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("Button").opacity(0.7), Color("Button").opacity(1)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            Image("Loading")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.white)
                .rotationEffect(.degrees(rot))
                .onReceive(timer, perform: { _ in
                    withAnimation(.easeIn){
                        rot += 10
                    }
                })
        }
    }
}

#Preview {
    LoadingView()
}
