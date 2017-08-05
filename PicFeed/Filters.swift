//
//  Filters.swift
//  PicFeed
//
//  Created by Brandon Holderman on 7/29/17.
//  Copyright © 2017 Brandon Holderman. All rights reserved.
//

import UIKit

typealias FilterCompletion = (UIImage?) -> ()

enum FilterNames: String {
    case CIPhotoEffectTransfer
    case CIPhotoEffectMono
    case CIPhotoEffectChrome
    case CIColorInvert
    case CIBoxBlur
    case CISRGBToneCurveToLinear
}

class Filters {
    static var originalImage = UIImage()
    
    class func filter(image: UIImage, withFilter filterName: FilterNames, completion: @escaping FilterCompletion) {
    
        OperationQueue().addOperation {
            
            guard let filter = CIFilter(name: filterName.rawValue) else {
                fatalError("There is an error with the filter name")
            }
            
            //GPU Context Code
            let coreImage = CIImage(image: image)
            filter.setValue(coreImage, forKey: kCIInputImageKey)
            
            let options = [kCIContextOutputColorSpace : NSNull()]
            guard let eAGLContext = EAGLContext(api: .openGLES2) else {
                fatalError("Issue accessing the GPU")
            }
            
            let context = CIContext(eaglContext: eAGLContext, options: options)
            
            //Get final image after being filtered
            if let outputImage = filter.outputImage {
                if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                    OperationQueue.main.addOperation {
                        completion(UIImage(cgImage: cgImage))
                    }
                }
            }
        }
    }
}
