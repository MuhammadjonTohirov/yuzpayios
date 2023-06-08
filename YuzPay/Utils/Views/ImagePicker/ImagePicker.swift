//
//  ImagePicker.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import UIKit
import SwiftUI
import Photos

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    @Binding var imageUrl: URL?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
                
                saveImageToPhotos(image: image) { [weak self] url in
                    DispatchQueue.main.async {
                        self?.parent.imageUrl = url
                        self?.parent.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        
        func saveImageToPhotos(image: UIImage, completion: @escaping (URL?) -> Void) {
            DispatchQueue.global(qos: .background).async {
                guard let data = image.jpegData(compressionQuality: 0.5 ) else {
                    completion(nil)
                    return
                }
                let temporaryFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension("jpeg")
                do {
                    try data.write(to: temporaryFileURL, options: .atomic)
                    completion(temporaryFileURL)
                } catch {
                    print("Error saving image: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
    }
}
