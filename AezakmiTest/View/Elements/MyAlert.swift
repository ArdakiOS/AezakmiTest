//
//  MyAlert.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 17.09.2024.
//

import SwiftUI

struct MyAlert: View {
    let title : String
    let msg : String
    @Binding var present : Bool
    var body: some View {
        VStack(spacing: 15){
            Text(title)
                .font(.system(size: 24, weight: .semibold))
            Text(msg)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color("Text2"))
                .multilineTextAlignment(.leading)
            Button {
                present = false
            } label: {
                Text("Ok")
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .frame(width: 250, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("Button"))
                    )
            }

        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("Border"))
        )
    }
}
