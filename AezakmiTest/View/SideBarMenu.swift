//
//  SideBarMenu.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 19.09.2024.
//

import SwiftUI

struct SideBarMenu: View {
    @EnvironmentObject var vm : FireBaseManager
    @Binding var isAuthenticated : Bool
    @Binding var showSideBar : Bool
    var body: some View {
        ZStack{
            Color.gray.ignoresSafeArea()
            VStack(alignment:.center, spacing: 20){
                Button {
                    showSideBar.toggle()
                } label: {
                    Image(systemName: "x.circle")
                        .font(.title2)
                        .bold()
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text("Your email")
                    .font(.title2)
                Text(vm.userData?.email ?? "Error")
                
                
                if vm.isEmailVerified(){
                    Text("Your email is verified")
                        .frame(width: 150,height: 55)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("Button"))
                        )
                }
                else{
                    if vm.emailSent{
                        Text("Please check your email")
                            .frame(width: 150,height: 55)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("Button"))
                            )
                    }
                    else{
                        Button {
                            Task{
                                try? await vm.sendEmail()
                            }
                        } label: {
                            Text("Verify your email")
                                .frame(width: 150,height: 55)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color("Button"))
                                )
                        }
                    }

                }
                                    
                
                Spacer()
                
                Button {
                    vm.signOut()
                    isAuthenticated = false
                } label: {
                    Text("Log out")
                        .frame(width: 150,height: 55)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("Button"))
                        )
                }
                
            }
            .padding()
            .foregroundStyle(.black)
            
        }
    }
}
