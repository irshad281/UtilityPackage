//
//  ImagePicker.swift
//  
//
//  Created by Irshad Ahmad on 24/04/22.
//

import Combine
import Foundation
import UIKit

public class ImagePicker: NSObject {
    public static let shared = ImagePicker()
    
    public typealias ImageCompletion = ((UIImage?) -> Void)
    private var imageClosure: ImageCompletion?
    private override init() { }
    
    public func showImagePicker(from sourceView: UIView?, completion: ImageCompletion?) {
        self.imageClosure = completion
        showActionSheet(sourceView: sourceView)
    }
    
    public func pickImage(from source: UIImagePickerController.SourceType, completion: ImageCompletion?) {
        self.imageClosure = completion
        switch source {
        case .camera: openCamera()
        case .photoLibrary: openGallary()
        default: break
        }
    }
    
    private func showActionSheet(sourceView: UIView?) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.openGallary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        actionSheet.popoverPresentationController?.sourceView = sourceView
        UIApplication.shared.currentController?.present(actionSheet,animated: true,completion: nil)
    }
    
    private func openCamera() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.camera
        myPickerController.modalPresentationStyle = .custom
        
        UIApplication.shared.currentController?.present(myPickerController,animated: true,completion: nil)
    }
    
    private func openGallary() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.delegate = self
        picker.modalPresentationStyle = .custom
        UIApplication.shared.currentController?.present(picker,animated: true,completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let pickedImage = info[.originalImage]as? UIImage {
                self.imageClosure?(pickedImage)
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
