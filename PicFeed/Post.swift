//
//  Post.swift
//  PicFeed
//
//  Created by Brandon Holderman on 7/27/17.
//  Copyright © 2017 Brandon Holderman. All rights reserved.
//

import UIKit
import CloudKit

enum RecordError: Error {
    case writingImageToData
    case writingDataToDisk
}

class Post {
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func record() throws -> CKRecord? {
        guard let data = UIImageJPEGRepresentation(self.image, 1.0) else { throw RecordError.writingImageToData }
        
        do {
            try data.write(to: image.path())
            
            let asset = CKAsset(fileURL: image.path())
            let postRecord = CKRecord(recordType: "Post")
            postRecord.setObject(asset, forKey: "image")
            
            return postRecord
        } catch {
            throw RecordError.writingDataToDisk
        }
    }
}
