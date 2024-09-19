//
//  FiltersSheet.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 18.09.2024.
//

import SwiftUI

struct FiltersSheet: View {
    @EnvironmentObject var vm : DrawingViewModel
    var body: some View {
        ScrollView(.horizontal) {
            HStack{
                ForEach(ImageFilter.allCases, id:\.self){ filter in
                    Button {
                        vm.loadImage(filter: filter)
                    } label: {
                        Text(filter.rawValue)
                            .foregroundStyle(.black)
                            .frame(height: 55)
                            .padding(.horizontal)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color("Button")))
                    }
                    
                }
            }
        }
    }
}

#Preview {
    FiltersSheet()
}
