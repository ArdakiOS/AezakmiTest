//
//  SheetToAddText.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 18.09.2024.
//

import SwiftUI

struct SheetToAddText: View {
    @EnvironmentObject var vm : DrawingViewModel
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(alignment: .center){
                Text("Add text")
                    .font(.title2)
                TextField("", text: $vm.editBox.text, prompt: Text("Add some text...").foregroundStyle(.black).font(.system(size: vm.editBox.font)))
                    .textInputAutocapitalization(.none)
                    .font(.system(size: vm.editBox.font))
                    .bold(vm.editBox.isBold)
                    .foregroundStyle(vm.editBox.color)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("Border"))
                    )
                
                HStack(spacing: 0){
                    Button {
                        vm.editBox.isBold.toggle()
                    } label: {
                        Text("Bold?")
                            .bold()
                            .frame(width: 50, height: 50)
                    }
                    
                    Button {
                        vm.editBox.font += 1
                    } label: {
                        Text("A")
                            .bold()
                            .frame(width: 50, height: 50)
                    }
                    
                    Button {
                        vm.editBox.font -= 1
                    } label: {
                        Text("a")
                            .frame(width: 50, height: 50)
                    }
                    
                    ColorPicker("", selection: $vm.editBox.color)
                        .frame(width: 50, height: 50)
                    
                    
                }
                
                HStack(spacing: 40){
                    Button {
                        if vm.isEditing{
                            vm.textBoxes[getIndex(textBox: vm.editBox)] = DrawingTextBoxModel(text: vm.editBox.text, color: vm.editBox.color, isBold: vm.editBox.isBold, font: vm.editBox.font)
                        }
                        else{
                            vm.textBoxes.append(DrawingTextBoxModel(text: vm.editBox.text, color: vm.editBox.color, isBold: vm.editBox.isBold, font: vm.editBox.font))
                        }
                        vm.addingTextBox = false
                        
                    } label: {
                        Text("Add")
                            .frame(width: 80, height: 55)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("Button"))
                            )
                    }
                    Button {
                        vm.addingTextBox = false
                    } label: {
                        Text("Cancel")
                            .frame(width: 80, height: 55)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.red)
                            )
                    }
                    
                }
                .bold()
                .foregroundStyle(.white)
            }
            .font(.system(size: 16))
            .onDisappear{
                vm.isEditing = false
                vm.addingTextBox = false
                vm.showToolPicker()
            }
            .padding()
            .foregroundStyle(.black)
            
        }
    }
    
    func getIndex(textBox : DrawingTextBoxModel) -> Int{
        return vm.textBoxes.firstIndex(where: { box in
            textBox.id == box.id
        }) ?? 0
    }
}

#Preview {
    SheetToAddText()
}
