//
//  HomeViewController.swift
//  PicFeed
//
//  Created by Brandon Holderman on 7/25/17.
//  Copyright © 2017 Brandon Holderman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var leadingConstraintForFilterButton: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraintForPostButton: NSLayoutConstraint!
    
    let kAnimationDuration = 0.6
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.selectedImageView.image != nil {
            animateInButtons()
        }
    }
    
    @IBAction func userTappedImage(_ sender: Any) {
        presentAlertController()
    }
    
    //Post Button
    @IBAction func postButtonPressed(_ sender: Any) {
        
        if let newImage = self.selectedImageView.image {
            
            let newPost = Post(image: newImage)
            
            CloudKit.shared.save(post: newPost, completion: { (success) in
                if success {
                    OperationQueue.main.addOperation {
                        self.selectedImageView.image = nil
                    }
                    print("Successfully Saved to the Cloud!")
                } else {
                    print("Unsuccessful in saving to CLoud...")
                }
            })
        }
    }
    
    //Filter button
    @IBAction func filterButtonPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Filters", message: "Select Filter:", preferredStyle: .alert)
        
        let chromeAction = alertActionForFilter(name: .CIPhotoEffectChrome, title: "Chrome")
        let monoAction = alertActionForFilter(name: .CIPhotoEffectMono, title: "Black and White")
        let vintageAction = alertActionForFilter(name: .CIPhotoEffectTransfer, title: "Vintage")
        
        alertController.addAction(chromeAction)
        alertController.addAction(monoAction)
        alertController.addAction(vintageAction)
        
        
        //Same code but using for loop and dictionary
//        let allFilters = ["Chrome" : FilterNames.CIPhotoEffectChrome,
//                          "Black and White" : .CIPhotoEffectMono,
//                          "Vintage" : .CIPhotoEffectTransfer]
//        
//        for (key, value) in allFilters {
//            let alertAction = alertActionForFilter(name: value, title: key)
//            alertController.addAction(alertAction)
//        }
//        
        self.present(alertController, animated: true, completion:  nil)
    }
    
    private func alertActionForFilter(name: FilterNames, title: String) -> UIAlertAction {
        let alertAction = UIAlertAction(title: title, style: .default) { (action) in
            if let imageViewImage = self.selectedImageView.image {
                Filters.filter(image: imageViewImage, withFilter: name, completion: { (filteredImage) in
                    self.selectedImageView.image = filteredImage
                })
            }
        }
        
        return alertAction
    }
    
    
    //Source selection alert
    func presentAlertController() {
        let alertController = UIAlertController(title: "", message: "Select Source", preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.presentImagePicker(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.presentImagePicker(sourceType: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
        
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = sourceType
        self.imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.selectedImageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func animateInButtons() {
        self.leadingConstraintForFilterButton.constant = 0
        self.trailingConstraintForPostButton.constant = 0
        
        UIView.animate(withDuration: kAnimationDuration) {
            self.view.layoutIfNeeded()
            self.selectedImageView.layer.cornerRadius = 15
        }
    }
}

