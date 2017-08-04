//
//  GalleryViewController.swift
//  PicFeed
//
//  Created by Brandon Holderman on 8/3/17.
//  Copyright © 2017 Brandon Holderman. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController,  UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
   
    
    var allPosts = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        cell.post = self.allPosts[indexPath.row]
        
        return cell
    }
}
