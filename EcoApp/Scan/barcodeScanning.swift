//
//  barcodeScanning.swift
//  barcode_scanner
//
//  Created by Saajidah Mohamed on 03/04/2024.
// https://www.patreon.com/posts/xcode-project-42828807


import Foundation

import UIKit
import SwiftUI
import AVFoundation


struct BarcodeScanning : UIViewControllerRepresentable {
    
    @Binding var barcode_string: String?
    @Binding var foundProduct: Product?
    
    @Environment(\.presentationMode) private var presentationMode
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.black
        
        context.coordinator.captureSession = AVCaptureSession()
        

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { fatalError() }
        let videoInput: AVCaptureDeviceInput
        videoInput = try! AVCaptureDeviceInput(device: videoCaptureDevice)
        

        if (context.coordinator.captureSession.canAddInput(videoInput)) {
            context.coordinator.captureSession.addInput(videoInput)
        } else {
            print("Could not add input to capture session")
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (context.coordinator.captureSession.canAddOutput(metadataOutput)) {
            context.coordinator.captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
           
            print("Outputproblem")
        }

        context.coordinator.previewLayer = AVCaptureVideoPreviewLayer(session: context.coordinator.captureSession)
        context.coordinator.previewLayer.frame = vc.view.layer.bounds
        context.coordinator.previewLayer.videoGravity = .resizeAspectFill
        vc.view.layer.addSublayer(context.coordinator.previewLayer)

        context.coordinator.captureSession.startRunning()
        
        
        return vc
    }
    
    
  
    
    class Coordinator : NSObject, AVCaptureMetadataOutputObjectsDelegate {
        let parent: BarcodeScanning
        
        var captureSession: AVCaptureSession!
        var previewLayer: AVCaptureVideoPreviewLayer!
        
        init(_ parent: BarcodeScanning) {
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(code: stringValue)
                captureSession.stopRunning()
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func found(code: String) {
            print(code)
            parent.barcode_string = code
            
          //  let barcodeToWordBe = BarcodeToWord()
            barcodeToWord().getProductName(barcode: code) { productinfo in
                DispatchQueue.main.async {
                    self.parent.foundProduct = productinfo
                }
            }
    
        }
        
    }
}
