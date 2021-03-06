//
//  HomeViewController.swift
//  PicFeed
//
//  Created by Brandon Holderman on 7/25/17.
//  Copyright © 2017 Brandon Holderman. All rights reserved.
//

import UIKit
import Social

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GalleryViewControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var leadingConstraintForFilterButton: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraintForPostButton: NSLayoutConstraint!
    
    let kPostAnimationDuration = 0.6
    let kFilterAnimationDuration = 0.6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBarController = self.tabBarController, let viewControllers = tabBarController.viewControllers {
            for viewController in viewControllers {
                if let galleryController = viewController as? GalleryViewController {
                    galleryController .delegate = self
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.selectedImageView.image != nil {
            animateInFilterButton()
            animateInPostButton()
        }
    }
    
    @IBAction func userTappedImage(_ sender: Any) {
        Filters.shared.createContext = true
        presentAlertController()
    }
    
//    @IBAction func userDoubleTappedImage(_ sender: Any) {
//        if Filters.undoImageFilters.count > 1 {
//            if self.selectedImageView.image == Filters.undoImageFilters.last {
//                Filters.undoImageFilters.removeLast()
//            }
//            self.selectedImageView.image = Filters.undoImageFilters.last
//        } else {
//            self.selectedImageView.image = Filters.originalImage
//        }
//    }
    
    
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
                    print("Unsuccessful in saving to Cloud...")
                }
            })
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        if Filters.undoImageFilters.count > 1 {
            if self.selectedImageView.image == Filters.undoImageFilters.last {
                Filters.undoImageFilters.removeLast()
            }
            self.selectedImageView.image = Filters.undoImageFilters.last
        } else {
            self.selectedImageView.image = Filters.originalImage
        }
    }
    
    //Filter button
    @IBAction func filterButtonPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Filters", message: "Select Filter:", preferredStyle: .alert)
        
        //Each option represented as it's own variable and alert action
        //        let chromeAction = alertActionForFilter(name: .CIPhotoEffectChrome, title: "Chrome")
        //        let monoAction = alertActionForFilter(name: .CIPhotoEffectMono, title: "Black and White")
        //        let vintageAction = alertActionForFilter(name: .CIPhotoEffectTransfer, title: "Vintage")
        //        let invertAction = alertActionForFilter(name: .CIColorInvert, title: "Invert")
        //        let blurAction = alertActionForFilter(name: .CIBoxBlur, title: "Blur")
        //        let curveAction = alertActionForFilter(name: .CISRGBToneCurveToLinear, title: "Color Curve")
        //
        //        alertController.addAction(chromeAction)
        //        alertController.addAction(monoAction)
        //        alertController.addAction(vintageAction)
        //        alertController.addAction(invertAction)
        //        alertController.addAction(blurAction)
        //        alertController.addAction(curveAction)
        
        //Same code but using a for loop and dictionary
        let allFilters = ["Chrome" : FilterNames.CIPhotoEffectChrome,
                          "Black and White" : .CIPhotoEffectMono,
                          "Vintage" : .CIPhotoEffectTransfer,
                          "Invert" : .CIColorInvert,
                          "Blur" : .CIBoxBlur,
                          "Color Curve" : .CISRGBToneCurveToLinear]
        
        for (key, value) in allFilters {
            let alertAction = alertActionForFilter(name: value, title: key)
            alertController.addAction(alertAction)
        }
        
        self.present(alertController, animated: true, completion:  nil)
    }
    
    @IBAction func userLongPressed(_ sender: UILongPressGestureRecognizer) {
        guard let image = self.selectedImageView.image else { return }
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            if let composedController = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
                composedController.add(image)
                
                self.present(composedController, animated: true, completion: nil)
            }
        }
    }
    
    private func alertActionForFilter(name: FilterNames, title: String) -> UIAlertAction {
        let alertAction = UIAlertAction(title: title, style: .default) { (action) in
            if let imageViewImage = self.selectedImageView.image {
                Filters.shared.filter(image: imageViewImage, withFilter: name, completion: { (filteredImage) in
                    self.selectedImageView.image = filteredImage
                    Filters.undoImageFilters.append(filteredImage!)
                })
            }
        }
        return alertAction
    }
    
    //Source selection alert
    func presentAlertController() {
        let alertController = UIAlertController(title: "Select Source", message: nil, preferredStyle: .actionSheet)
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
            print(image, "pic selected")
            self.selectedImageView.image = image
            Filters.originalImage = image
            Filters.undoImageFilters.append(image)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(didSelect image: UIImage) {
        self.selectedImageView.image = image
        self.tabBarController?.selectedIndex = 0
    }
    
    func animateInFilterButton() {
        self.leadingConstraintForFilterButton.constant = 0
        
        UIView.animate(withDuration: kFilterAnimationDuration) {
            self.view.layoutIfNeeded()
            self.selectedImageView.layer.cornerRadius = 10
        }
    }
    
    func animateInPostButton() {
        self.trailingConstraintForPostButton.constant = 0
        
        UIView.animate(withDuration: kPostAnimationDuration) {
            self.view.layoutIfNeeded()
            self.selectedImageView.layer.cornerRadius = 10
        }
    }
}
