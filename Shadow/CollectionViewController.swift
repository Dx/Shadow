//
//  ViewController.swift
//  UICollectionView
//
//  Created by Brian Coleman on 2014-09-04.
//  Copyright (c) 2014 Brian Coleman. All rights reserved.
//

import UIKit
import MobileCoreServices

@objc
protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func collapseSidePanels()
}

class CollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, SidePanelViewControllerDelegate {
    
    var delegate: CenterViewControllerDelegate?
    
    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    var beenHereBefore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 90)
//        let endFrame = CGRectMake()
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        
        self.collectionView?.delegate = self
    }
    
    func menuItemSelected(menuItem: MenuItem) {
        imageView.image = menuItem.image
        titleLabel.text = menuItem.title
        
        delegate?.collapseSidePanels?()
    }
    
    @IBAction func menuTapped(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getElementCount(getPath())
    }
    
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
            
    }
    
    func getElementCount(path: String) -> Int {
        var count = contentsOfDirectoryAtPath(path)?.count
        if count > 0 {
            return count!
        }
        else {
            return 0
        }
    }
    
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
    
    func getPath() -> NSString {
        
        let fileManager = NSFileManager.defaultManager()
        
        let containerURL = fileManager.containerURLForSecurityApplicationGroupIdentifier("group.palmera.shadow")!.URLByAppendingPathComponent("ShadowMedia")
        
        fileManager.createDirectoryAtURL(containerURL, withIntermediateDirectories: true, attributes: nil, error:nil)
        
        return containerURL.path!
    }
    

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let documentsPath = getPath()
        

        let appBundleContents = contentsOfDirectoryAtPath(documentsPath)
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as CollectionViewCell
        
        if let contents = appBundleContents as [NSString]! {
            let url = contents[indexPath.row]
            cell.backgroundColor = UIColor.blackColor()
            cell.textLabel?.text = "\(indexPath.section):\(indexPath.row)"
                
            var data = NSData(contentsOfURL: NSURL.fileURLWithPath(documentsPath + "/" + url)!)
            cell.imageView?.image = UIImage(data: data!)
        }
        
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isCameraAvailable() -> Bool{
        var result = UIImagePickerController.isSourceTypeAvailable(.Camera)
        return result
    }
    
    func cameraSupportsMedia(mediaType: String,
        sourceType: UIImagePickerControllerSourceType) -> Bool{
            
            let availableMediaTypes =
            UIImagePickerController.availableMediaTypesForSourceType(sourceType) as
                [String]?
            
            if let types = availableMediaTypes{
                for type in types{
                    if type == mediaType{
                        return true
                    }
                }
            }
            
            return false
    }
    
    func doesCameraSupportTakingPhotos() -> Bool{
        var result = cameraSupportsMedia(kUTTypeImage as NSString, sourceType: .Camera)
        return result
    }
    
    @IBAction func takePic(sender : AnyObject) {
//        if beenHereBefore{
//            /* Only display the picker once as the viewDidAppear: method gets
//            called whenever the view of our view controller gets displayed */
//            return;
//        } else {
//            beenHereBefore = true
//        }
//        
//        if isCameraAvailable() && doesCameraSupportTakingPhotos(){
//            
//            controller = UIImagePickerController()
//            
//            if let theController = controller{
//                theController.sourceType = .Camera
//                
//                theController.mediaTypes = [kUTTypeImage as NSString]
//                
//                theController.allowsEditing = true
//                theController.delegate = self
//                
//                presentViewController(theController, animated: true, completion: nil)
//            }
//            
//        } else {
//            println("Camera is not available")
//        }
    }

}

