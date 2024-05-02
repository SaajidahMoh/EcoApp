//
//  ImagePicker.swift
//  EcoApp
//
//  Created by Saajidah Mohamed
//

import SwiftUI

/**
 * The image picker file was reused from Youtube,  Lets Build That App - SwiftUI Firebase Chat 03: Save Images to Firebase Storage [https://www.youtube.com/watch?v=olV5wVf-tsE&ab_channel=Ayhan]
 * Voong, B. (2021), Save Images to Firebase Storage - SwiftUI Firebase Real Time Chat.  Published by: Lets Build That App. Source code available at:  https://www.letsbuildthatapp.com/courses/SwiftUI-Firebase-Real-Time-Chat/Save-Images-to-Firebase-Storage
 */

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    
    private let controller = UIImagePickerController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
