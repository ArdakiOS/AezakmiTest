//
//  AuthNav.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 17.09.2024.
//

import SwiftUI

enum AuthPages{
    case main, newAcc
}

struct AuthNav: View {
    @State var curPage = AuthPages.main
    @Binding var isAuthenticated : Bool
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            switch curPage {
            case .main:
                AuthMain(curPage: $curPage, isAuthenticated: $isAuthenticated)
                    .transition(.move(edge: .trailing))
            case .newAcc:
                AuthNewAcc(curPage: $curPage, isAuthenticated: $isAuthenticated)
                    .transition(.move(edge: .trailing))
            }
        
        }
        .animation(.easeInOut(duration: 0.4), value: curPage)
    }
}

#Preview {
    WelcomeView()
}
