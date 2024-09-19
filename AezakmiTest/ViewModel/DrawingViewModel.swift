//
//  DrawingViewModel.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 18.09.2024.
//

import Foundation
import PhotosUI
import SwiftUI
import PencilKit
import CoreImage
import CoreImage.CIFilterBuiltins


enum ImageFilter: String, CaseIterable {
    case sepiaTone = "Sepia Tone"
    case gaussianBlur = "Gaussian Blur"
    case photoEffectMono = "Photo Effect Mono"
    case photoEffectNoir = "Photo Effect Noir"
    case colorInvert = "Color Invert"
    case colorMonochrome = "Color Monochrome"
    case crystallize = "Crystallize"
    case exposureAdjust = "Exposure Adjust"
    case bloom = "Bloom"
    case pixellate = "Pixellate"
}

class DrawingViewModel : ObservableObject {
    @Published var images = [UIImage]()
    @Published var selectedPhotos = [PhotosPickerItem]()
    
    @Published var canvas = PKCanvasView()
    @Published var picker = PKToolPicker()
    
    @Published var listOfTextBoxes : [DrawingTextBoxModel] = []
    
    @Published var addingTextBox = false
    
    @Published var textBoxes : [DrawingTextBoxModel] = []
    
    @Published var rect : CGRect = .zero
    
    @Published var scale: CGFloat = 1.0
    @Published var lastScale = 0.0
    @Published var rotation = Angle(degrees: 0)
    @Published var lastRotation = Angle(degrees: 0)
    
    @Published var editBox = DrawingTextBoxModel(text: "")
    @Published var isEditing = false
    
    @Published var saved = false
    
    @Published var selectingFilters = false
    @Published var initImage : UIImage?
    
    @Published var imageIsLoading = false
    
    @MainActor
    func convertDataToImage() {
        // reset the images array before adding more/new photos
        initImage = nil
        images.removeAll()
        
        
        if !selectedPhotos.isEmpty {
            for eachItem in selectedPhotos {
                Task {
                    if let imageData = try? await eachItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: imageData) {
                            images.append(image)
                        }
                    }
                }
            }
        }
        
        // uncheck the images in the system photo picker
        selectedPhotos.removeAll()
        
        
    }
    
    @MainActor
    func loadImage(filter: ImageFilter) {
        guard images.count > 0 else { return}
        if initImage == nil{
            initImage = images[0]
        }
        let inputImg = initImage
        guard let beginImage = CIImage(image: inputImg!) else { return }
        
        let context = CIContext()
        let ciFilter: CIFilter
        
        switch filter {
        case .sepiaTone:
            ciFilter = CIFilter.sepiaTone()
            
        case .gaussianBlur:
            ciFilter = CIFilter.gaussianBlur()
            
        case .photoEffectMono:
            ciFilter = CIFilter.photoEffectMono()
            
        case .photoEffectNoir:
            ciFilter = CIFilter.photoEffectNoir()
            
        case .colorInvert:
            ciFilter = CIFilter.colorInvert()
            
        case .colorMonochrome:
            ciFilter = CIFilter.colorMonochrome()
            ciFilter.setValue(CIColor(red: 0.5, green: 0.5, blue: 0.5), forKey: kCIInputColorKey)
            ciFilter.setValue(1.0, forKey: kCIInputIntensityKey)
            
        case .crystallize:
            ciFilter = CIFilter.crystallize()
            ciFilter.setValue(50.0, forKey: kCIInputRadiusKey)
            
        case .exposureAdjust:
            ciFilter = CIFilter.exposureAdjust()
            ciFilter.setValue(1.0, forKey: kCIInputEVKey) // Example exposure value
            
        case .bloom:
            ciFilter = CIFilter.bloom()
            ciFilter.setValue(10.0, forKey: kCIInputRadiusKey)
            ciFilter.setValue(0.5, forKey: kCIInputIntensityKey)
            
        case .pixellate:
            ciFilter = CIFilter.pixellate()
            ciFilter.setValue(10.0, forKey: kCIInputScaleKey)
            
        }
        
        ciFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        guard let outputImage = ciFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage, scale: inputImg!.scale, orientation: inputImg!.imageOrientation)
        
        images[0] = uiImage
        
    }
    
    func hideToolPicker() {
        picker.setVisible(false, forFirstResponder: canvas)
        canvas.resignFirstResponder()
    }
    
    func showToolPicker() {
        picker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
    }
    
    func resetEverything() {
        rotation = Angle(degrees: 0)
        lastRotation = Angle(degrees: 0)
        scale = 1.0
        lastScale = 0.0
        saved = false
        
        images = []
        textBoxes = []
        canvas.drawing = PKDrawing()
    }
}
