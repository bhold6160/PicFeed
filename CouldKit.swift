//
//  CouldKit.swift
//  PicFeed
//
//  Created by Brandon Holderman on 7/25/17.
//  Copyright © 2017 Brandon Holderman. All rights reserved.
//

import Foundation
import CloudKit

class CloudKit {
    static let shared = CloudKit()
    
    let container = CKContainer.default()
    
    var database : CKDatabase {
        //Change to public if desired
        return container.privateCloudDatabase
    }
    
    private init (){}
}
