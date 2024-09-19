//
//  FireBaseManager.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 17.09.2024.
//

import Foundation
import FirebaseAuth
import UIKit
import GoogleSignIn


class FireBaseManager : ObservableObject{
    
    @Published var userData : User?
    
    @Published var existButNotVerified = false
    @Published var emailSent = false
    
    @MainActor
    func createUser(email : String, pass: String) async throws{
        let data = try await Auth.auth().createUser(withEmail: email, password: pass)
        userData = data.user
        
    }
    @MainActor
    func sendEmail() async throws {
        try await Auth.auth().currentUser?.sendEmailVerification()
        emailSent = true
    }
    @MainActor
    func loginUser(email : String, pass : String) async throws{
        let data = try await Auth.auth().signIn(withEmail: email, password: pass)
        
        userData = data.user
    }
    
    func isAuthenticated() -> Bool {
        if let user = Auth.auth().currentUser {
            userData = user
            return true
        }
        else {
            return false
        }
    }
    
    func isEmailVerified() -> Bool {
        if let user = Auth.auth().currentUser{
            if user.emailVerified() {
                return true
            }
            else{
                return false
            }
        }
        else {
            return false
        }
    }
    
    func signOut() {
        do{
            try Auth.auth().signOut()
        }
        catch{
            print("Could not signout")
        }
    }
    
    func reserPassword(email: String) async throws{
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    @MainActor
    func signInWithGoogle() async throws{
        guard let topVC = UIApplication.topViewController() else{
            print("NO top VC")
            return
        }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = result.user.idToken?.tokenString else {
            print("NO ID TOKEN")
            return
        }
        let accessToken = result.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        try await signInWithCredential(credential: credential)
    }
    @MainActor
    func signInWithCredential(credential : AuthCredential) async throws{
        try await Auth.auth().signIn(with: credential)
    }
}
