//
//  CanvasView.swift
//  AezakmiTest
//
//  Created by Ardak Tursunbayev on 18.09.2024.
//
import PencilKit
import UIKit
import Foundation
import SwiftUI

struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var picker : PKToolPicker
    @Binding var img: UIImage
    
    @Binding var showTools : Bool
    @Binding var imgIsLoading : Bool
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        self.canvasView.isOpaque = false
        self.canvasView.backgroundColor = UIColor.clear
        self.canvasView.drawingPolicy = .anyInput
        
        addImageToCanvas()
        
        picker.setVisible(true, forFirstResponder: canvasView)
        picker.addObserver(canvasView)
        canvasView.becomeFirstResponder()

        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        addImageToCanvas()
        
    }
    
    private func addImageToCanvas() {
        // Remove any existing background image
        for subview in canvasView.subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }
        
        // Create and add the new image view as a background
        let imageView = UIImageView(image: img)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = canvasView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Insert imageView at the back so it acts as a background
        canvasView.insertSubview(imageView, at: 0)
    }
}
