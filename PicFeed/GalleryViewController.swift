//
//  GalleryViewController.swift
//  PicFeed
//
//  Created by Brandon Holderman on 8/3/17.
//  Copyright © 2017 Brandon Holderman. All rights reserved.
//

import UIKit

protocol GalleryViewControllerDelegate: class {
    func galleryController(didSelect image: UIImage)
}

class GalleryViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: GalleryViewControllerDelegate?
   
    var allPosts = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = GalleryFlowLayout(columns: 4)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        CloudKit.shared.getPosts { (posts) in
            if let posts = posts {
                self.allPosts = posts
            }
        }
    }
    
    @IBAction func userPinchedCollectionView(_ sender: UIPinchGestureRecognizer) {
        guard let layout = collectionView.collectionViewLayout as? GalleryFlowLayout else { return }
        
        switch sender.state {
        case .began:
            print("User started pinch")
        case .changed:
            print("Pinch changed!")
            
            if sender.velocity > 0 && layout.columns == 1 {
                self.collectionView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
            }
        case .ended:
            print("User completed pinch gesture")
            if sender.velocity > 0 {
                layout.columns -= 1
            } else if sender.velocity < 0 {
                layout.columns += 1
            }
            
            if layout.columns == 1 {
                UIView.animate(withDuration: 0.25, animations: { 
                    self.collectionView.transform = CGAffineTransform.identity
                })
            }
            
            if layout.columns <= 0 {
                return
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                let newLayout = GalleryFlowLayout(columns: layout.columns)
                self.collectionView.setCollectionViewLayout(newLayout, animated: true)
            })
        default:
            print(sender.state)
        }
    }
    
//    @IBAction func userLongPressedImage(_ sender: UILongPressGestureRecognizer) {
//        print(sender.view!)
//        
//        if let collectionView = sender.view as? UICollectionView, let indexCell = collectionView.indexPathsForSelectedItems {
//           if let selectedIndex = indexCell.first {
//                let image = self.allPosts[selectedIndex.row].image
//                
//                print(image)
//            }
//        }
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        cell.post = self.allPosts[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            let selectedPost = self.allPosts[indexPath.row]
            
            delegate.galleryController(didSelect: selectedPost.image)
        }
    }
}





