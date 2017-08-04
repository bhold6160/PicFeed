//
//  PostCell.swift
//  PicFeed
//
//  Created by Brandon Holderman on 8/3/17.
//  Copyright © 2017 Brandon Holderman. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    var post: Post! {
        didSet {
            self.postImageView.image = post.image
        }
    }
}
