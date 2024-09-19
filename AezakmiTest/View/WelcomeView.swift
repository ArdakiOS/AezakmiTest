//
//  WelcomeView.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 17.09.2024.
//

import SwiftUI

struct WelcomeView: View {
    @State var isAuthenticated = true
    @EnvironmentObject var fireBaseVM : FireBaseManager
    var body: some View {
        ZStack{
            if !isAuthenticated{
                AuthNav(isAuthenticated: $isAuthenticated)
                    
            }
            else{
                NavigationView(isAuthenticated: $isAuthenticated)
            }
        }
        .environmentObject(fireBaseVM)
        .onAppear{
            isAuthenticated = fireBaseVM.isAuthenticated()
        }
        .animation(.easeIn(duration: 0.3), value: isAuthenticated)
    }
}

#Preview {
    WelcomeView()
}
