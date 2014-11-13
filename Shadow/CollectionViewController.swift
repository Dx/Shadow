//
//  ViewController.swift
//  UICollectionView
//
//  Created by Brian Coleman on 2014-09-04.
//  Copyright (c) 2014 Brian Coleman. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 90)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
//    func contentsOfAppBundle() -> (filenames:[String]?) {
//        
//        var error : NSError? = nil
//        let fileManager = NSFileManager.defaultManager()
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
//        
//        let result = fileManager.contentsOfDirectoryAtPath(documentsPath, error: &error)
//        
//        if let theError = error{
//            println("An error occurred")
//        }
//        
//        return result
//    }
    
    func contentsOfDirectoryAtPath(path: String) -> ([NSString]?) {
        var error: NSError? = nil
        let fileManager = NSFileManager.defaultManager()
        let contents = fileManager.contentsOfDirectoryAtPath(path, error: &error)
        if contents != nil {
            let filenames = contents as [NSString]
            return filenames
        } else {
            return nil
        }
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let appBundleContents = contentsOfDirectoryAtPath(documentsPath)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as CollectionViewCell
        
        if let contents = appBundleContents as [NSString]! {
            for url in contents {

                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as  CollectionViewCell
                cell.backgroundColor = UIColor.blackColor()
                cell.textLabel?.text = "\(indexPath.section):\(indexPath.row)"
            
                var data = NSData(contentsOfURL: NSURL.fileURLWithPath(documentsPath + "/" + url)!)
                cell.imageView?.image = UIImage(data: data!)
            
            }
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

