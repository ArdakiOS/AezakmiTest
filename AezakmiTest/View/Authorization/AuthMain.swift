//
//  AuthMain.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 17.09.2024.
//

import SwiftUI


struct AuthMain: View {
    @State var email = ""
    @State var pass = ""
    
    @Binding var curPage : AuthPages
    @EnvironmentObject var fireBaseVM : FireBaseManager
    
    @Binding var isAuthenticated : Bool
    @State var errorOccured = false
    @State var errorMessage = ""
    @State var loadingAnimation = false
    @State var alert = false
    @FocusState var focusedText : Bool
    var body: some View {
        ZStack{
            if loadingAnimation {
                LoadingView()
            }
            else{
                VStack(spacing: 20){
                    VStack(spacing: 10){
                        Text("Login")
                            .font(.system(size: 24, weight: .semibold))
                        
                        Text("Welcome back! Please enter your credentials to login")
                            .font(.system(size: 16, weight: .regular))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("Text2"))
                    }
                    
                    VStack(alignment: .leading, spacing: 20){
                        MyStyledTextField(name: "Email*", prompt: "Enter your email", variable: $email, focus: $focusedText)
                            .frame(height: 70)
                        
                        MyStyledSecureField(name: "Password*", prompt: "••••••••", variable: $pass, focus: $focusedText)
                            .frame(height: 70)
                        HStack{
                            Spacer()
                            Button {
                                if email.isEmpty{
                                    errorMessage = "Please enter your email"
                                    errorOccured = true
                                }
                                else{
                                    Task{
                                        do{
                                            try await fireBaseVM.reserPassword(email: email)
                                            errorMessage = "Message sent to your email"
                                            alert = true
                                        }
                                        catch{
                                            print("RESet error")
                                            errorMessage = "Could not send message to your email"
                                            errorOccured = true
                                        }
                                    }
                                }
                            } label: {
                                Text("Forgot password?")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color("Button"))
                            }
                            
                        }
                        .frame(height: 20)
                    }
                    VStack(spacing:20){
                        Button {
                            Task{
                                do{
                                    loadingAnimation = true
                                    try await fireBaseVM.loginUser(email: email, pass: pass)
                                    isAuthenticated = fireBaseVM.isAuthenticated()
                                    loadingAnimation = false
                                }
                                catch{
                                    loadingAnimation = false
                                    print("ERROR IN SIGN IN \(error._code)")
                                    errorMessage = error.localizedDescription
                                    errorOccured = true
                                }
                            }
                            
                        } label: {
                            Text("Login")
                                .foregroundStyle(.white)
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .frame(width: 343, height: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(email.isEmpty || pass.isEmpty ? Color.gray : Color("Button"))
                                )
                        }
                        .disabled(email.isEmpty || pass.isEmpty)
                        
                        Button {
                            Task{
                                do {
                                    loadingAnimation = true
                                    try await fireBaseVM.signInWithGoogle()
                                    isAuthenticated = fireBaseVM.isAuthenticated()
                                    loadingAnimation = false
                                }
                                catch{
                                    loadingAnimation = false
                                    print("Could not sign in with Google\(error)\n\n\n\n\(error.localizedDescription)")
                                }
                            }
                            
                        } label: {
                            HStack{
                                Image("AuthGoogle")
                                    .resizable()
                                    .frame(width: 30)
                                    .clipShape(Circle())
                                Text("Login using Google")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color("Text1"))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .frame(width: 343, height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("Border"))
                            )
                        }
                        
                        
                    }
                    
                    HStack{
                        Text("New member?")
                            .font(.system(size: 14, weight: .regular))
                        Button {
                            curPage = .newAcc
                        } label: {
                            Text("Sign Up")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color("Button"))
                        }
                        
                    }
                    .frame(height: 20)
                    
                    Spacer()
                    
                    HStack(spacing: 5){
                        Text("Terms")
                            .foregroundStyle(Color("Button"))
                            .font(.system(size: 12, weight: .semibold))
                        Text("and")
                            .font(.system(size: 12, weight: .regular))
                        Text("Privacy policy ")
                            .foregroundStyle(Color("Button"))
                            .font(.system(size: 12, weight: .semibold))
                    }
                    
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .frame(height: 59)
                }
                
                .padding(.top, 30)
                .foregroundStyle(.black)
                .frame(width: 343)
                .overlay(content: {
                    if errorOccured{
                        MyAlert(title: "Error", msg: errorMessage, present: $errorOccured)
                    }
                })
                .overlay(content: {
                    if alert{
                        MyAlert(title: "Alert", msg: errorMessage, present: $alert)
                    }
                })
            }
        }
        .onTapGesture {
            focusedText = false
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
        
    }
}

#Preview {
    AuthNav(curPage: .main, isAuthenticated: .constant(false))
}
