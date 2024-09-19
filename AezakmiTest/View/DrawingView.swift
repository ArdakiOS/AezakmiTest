//
//  DrawingView.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 18.09.2024.
//

import SwiftUI

struct DrawingView: View {
    @EnvironmentObject var vm : DrawingViewModel
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var rot = 0.0
    var body: some View {
        if vm.images.count > 0 {
            ZStack{
                CanvasView(canvasView: $vm.canvas, picker: $vm.picker, img: $vm.images[0], showTools: $vm.addingTextBox, imgIsLoading: $vm.imageIsLoading)
                    .onAppear{
                        vm.imageIsLoading = false
                    }
                ForEach(vm.textBoxes) {box in
                    Text(box.text)
                        .font(.system(size: box.font))
                        .bold(box.isBold)
                        .foregroundStyle(box.color)
                        .offset(box.offset)
                        .gesture(
                            DragGesture().onChanged({ value in
                                let translation = value.translation
                                let lastoffset = box.lastOffset
                                let newTranslation = CGSize(width: lastoffset.width + translation.width, height: lastoffset.height + translation.height)
                                
                                vm.textBoxes[getIndex(textBox: box)].offset = newTranslation
                            }).onEnded({ value in
                                vm.textBoxes[getIndex(textBox: box)].lastOffset = value.translation
                            }))
                        .onLongPressGesture {
                            vm.editBox = box
                            vm.isEditing = true
                            vm.addingTextBox = true
                        }
                    
                }
            }
            .rotationEffect(vm.rotation)
            .scaleEffect(vm.scale)
            .gesture(
                MagnificationGesture(minimumScaleDelta: 0)
                    .onChanged { value in
                        withAnimation(.interactiveSpring()) {
                            vm.scale = handleScaleChange(value)
                        }
                    }
                    .onEnded { _ in
                        vm.lastScale = vm.scale
                    }
                    .simultaneously(with:
                                        RotationGesture()
                        .onChanged { value in
                            withAnimation(.interactiveSpring()) {
                                vm.rotation = handleRotationChange(value)
                            }
                        }
                        .onEnded { _ in
                            vm.lastRotation = vm.rotation
                        }
                                   )
            )
            
            
        }
        else{
            if vm.imageIsLoading{
                Image("Loading")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.black)
                    .bold()
                    .rotationEffect(.degrees(rot))
                    .onReceive(timer, perform: { _ in
                        withAnimation(.easeIn){
                            rot += 10
                        }
                    })
            }
            else{
                Text("No image is selected")
                    .font(.title)
            }
        }
        
    }
    
    func getIndex(textBox : DrawingTextBoxModel) -> Int{
        return vm.textBoxes.firstIndex(where: { box in
            textBox.id == box.id
        }) ?? 0
    }
    
    func handleRotationChange(_ angle: Angle) -> Angle {
        vm.lastRotation + angle
    }
    
    
    func handleScaleChange(_ zoom: CGFloat) -> CGFloat {
        vm.lastScale + zoom - (vm.lastScale == 0 ? 0 : 1)
    }
}

#Preview {
    DrawingView()
}
