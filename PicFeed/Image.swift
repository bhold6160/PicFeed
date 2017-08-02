//
//  Image.swift
//  PicFeed
//
//  Created by Brandon Holderman on 7/31/17.
//  Copyright © 2017 Brandon Holderman. All rights reserved.
//

import UIKit

// public class Image {
//        let pixels: UnsafeMutableBufferPointer<RGBAPixel>
//        let height: Int
//        let width: Int
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
//        let bitsPerComponent = 8
//        let bytesPerRow: Int
//        
//        init( image: UIImage ) {
//            height = Int(image.size.height)
//            width = Int(image.size.width)
//            bytesPerRow = 4 * width
//            
//            let rawdata = UnsafeMutablePointer<RGBAPixel>.allocate(capacity: (width * height))
//            let imageContext = CGBitmapContextReleaseDataCallback(rawdata, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo)
//            CGContextDrawImage(imageContext, CGRect(origin: CGPointZero, size: image.size), image.CGImage)
//            
//            pixels = unsafeMutableBufferPointer<RGBAPixel>(start: rawdata, count: width * height)
//        }
//        
//        public func toUIImage() -> UIImage {
//            let outContext = CGbitmapContextCreateWithData(pixels.baseAddress, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo, nil, nil)
//            return UIImage(CGImage: CGBitmapContextCreateImage(outContext)!)
//        }
//    }

