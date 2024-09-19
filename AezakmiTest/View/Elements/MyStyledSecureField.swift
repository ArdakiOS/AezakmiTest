//
//  MyStyledSecureField.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 17.09.2024.
//

import SwiftUI

struct MyStyledSecureField: View {
    let name : String
    let prompt : String
    @Binding var variable : String
    @FocusState.Binding var focus : Bool
    var body: some View {
        VStack(alignment:.leading, spacing: 0){
            Text(name)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color("Text1"))
            Spacer()
            SecureField("", text: $variable, prompt: Text(prompt).foregroundStyle(Color("Text3")))
                .focused($focus)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .frame(width: 343, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Border"),lineWidth: 1)
                )
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}
