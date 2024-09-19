//
//  DrawView.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 18.09.2024.
//

import SwiftUI
import PhotosUI
import PencilKit

struct EditorPage: View {
    @StateObject var vm = DrawingViewModel()
    
    @State private var zStackSize: CGSize = .zero
    
    let maxPhotosToSelect = 1
    @Binding var sideMenu : Bool

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                HStack(spacing: 10){
                    Button {
                        sideMenu = true
                    } label: {
                        Image(systemName: "sidebar.leading")
                            .bold()
                    }
                    
                    Text("Photo editor")
                        .font(.title3)
                    Spacer()
                    
                    if vm.images.count == 0{
                        PhotosPicker(
                            selection: $vm.selectedPhotos,
                            maxSelectionCount: maxPhotosToSelect,
                            selectionBehavior: .ordered,
                            matching: .images
                        ) {
                            
                            Image(systemName: "photo")
                                .bold()
                            
                        }
                    }
                    else{
                        Button {
                            vm.selectingFilters = true
                        } label: {
                            Text("Filters")
                                .bold()
                                .foregroundStyle(Color("Button"))
                            
                        }
                        
                        Button {
                            
                            let image = DrawingView().environmentObject(vm).frame(width: zStackSize.width, height: zStackSize.height).saveSnapshotToPhotoLibrary()
                            if let uiImage = UIImage(data: image){
                                let activityViewController = UIActivityViewController(activityItems: [uiImage], applicationActivities: nil)
                                // Present the share sheet modally
                                UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                            }
                            vm.resetEverything()
                            
                        } label: {
                            Text("Save")
                                .bold()
                                .foregroundStyle(Color("Button"))
                        }
                        
                        Button {
                            vm.addingTextBox = true
                            vm.hideToolPicker()
                        } label: {
                            Text("Text")
                        }
                        Button {
                            vm.resetEverything()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        
                    }
                }
                .frame(width: 343, alignment: .center)
                Spacer()
                
                DrawingView()
                    .environmentObject(vm)
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    zStackSize = geometry.size
                                }
                        }
                    )
                    .frame(maxHeight: .infinity)
                Spacer()
            }
            .frame(maxWidth: 343)
            .padding()
            .onChange(of: vm.selectedPhotos) { _, _ in
                vm.convertDataToImage()
                vm.imageIsLoading = true
            }
            .sheet(isPresented: $vm.addingTextBox, content: {
                SheetToAddText()
                    .environmentObject(vm)
                    .presentationDetents([.fraction(1/3)])
            })
            .sheet(isPresented: $vm.selectingFilters, content: {
                FiltersSheet()
                    .environmentObject(vm)
                    .presentationDetents([.fraction(1/4)])
            })
        }
        .onChange(of: sideMenu, { oldValue, newValue in
            if newValue == true {
                vm.hideToolPicker()
            }
            else {
                vm.showToolPicker()
            }
        })
        
        .onTapGesture {
            sideMenu = false
        }
        .onDisappear{
            vm.resetEverything()
        }
        .animation(.easeIn(duration: 0.4))
        .foregroundStyle(.black)
        
    }
    
}

