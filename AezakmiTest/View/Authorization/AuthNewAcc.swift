//
//  AuthNewAcc.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 17.09.2024.
//
import SwiftUI


struct AuthNewAcc: View {
    @State var email = ""
    @State var pass = ""
    @State var minEight = false
    @State var validEmail = false
    
    @Binding var curPage : AuthPages
    @EnvironmentObject var fireBaseVM : FireBaseManager
    
    @Binding var isAuthenticated : Bool
    @State var errorOccured = false
    @State var errorMessage = ""
    @State var loadingAnimation = false
    @FocusState var focusedText : Bool
    var body: some View {
        
        if loadingAnimation{
            LoadingView()
        }
        else{
            VStack(spacing: 20){
                Spacer()
                VStack(spacing: 10){
                    Text("Create an account")
                        .font(.system(size: 24, weight: .semibold))
                    Text("Create an account to use our app")
                        .font(.system(size: 16, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("Text2"))
                }
                VStack(alignment: .leading, spacing: 20){
                    MyStyledTextField(name: "Email*", prompt: "Enter your email", variable: $email, focus: $focusedText)
                        .frame(height: 70)
                    
                    MyStyledSecureField(name: "Password*", prompt: "••••••••", variable: $pass, focus: $focusedText)
                        .frame(height: 70)
                    
                    
                    HStack(spacing: 8){
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(minEight ? Color.green : Color("Border"))
                        Text("Password must be at least 8 characters long")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color("Text2"))
                    }
                    
                    HStack(spacing: 8){
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(validEmail ? Color.green : Color("Border"))
                        Text("Email must be of valid format")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color("Text2"))
                    }
                    
                }
                
                Button {
                    Task{
                        do{
                            loadingAnimation = true
                            try await fireBaseVM.createUser(email: email, pass: pass)
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
                    Text("Sign Up")
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .frame(width: 343, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(validEmail && minEight ? Color("Button") : Color.gray)
                        )
                }
                .disabled(!validEmail || !minEight)
                HStack{
                    Text("You already have an account?")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color("Text2"))
                    Button {
                        curPage = .main
                    } label: {
                        Text("Login")
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
            .foregroundStyle(.black)
            .padding(.top, 30)
            .onChange(of: email, { oldValue, newValue in
                if newValue.contains("@") && newValue.contains("."){
                    validEmail = true
                }
                else{
                    validEmail = false
                }
            })
            .onChange(of: pass, { oldValue, newValue in
                if newValue.count >= 8 {
                    minEight = true
                }
                else {
                    minEight = false
                }
            })
            .frame(width: 343)
            .animation(.easeIn(duration: 0.5), value: loadingAnimation)
            .overlay(content: {
                if errorOccured{
                    MyAlert(title: "Error", msg: errorMessage, present: $errorOccured)
                }
            })
            .onTapGesture {
                focusedText = false
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        
    }
}

#Preview {
    AuthNav(curPage: .newAcc, isAuthenticated: .constant(false))
}
