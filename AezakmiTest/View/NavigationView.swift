//
//  NavigationView.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 17.09.2024.
//

import SwiftUI


struct NavigationView: View {
    @Binding var isAuthenticated : Bool
    @EnvironmentObject var vm : FireBaseManager
    @State var showSideBar = false
    var body: some View {
        ZStack(alignment: .leading){
            EditorPage(sideMenu: $showSideBar)
                .frame(maxWidth: .infinity)
            if showSideBar {
                SideBarMenu(isAuthenticated: $isAuthenticated, showSideBar: $showSideBar)
                    .frame(maxHeight: .infinity)
                    .frame(width: 200)
                    .transition(.move(edge: .leading))
                    .environmentObject(vm)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.3), value: showSideBar)
        
        
        
    }
}

#Preview {
    WelcomeView()
}
