//
//  ViewController.swift
//  BlurrySideBar
//
//  Created by Training on 01/09/14.
//  Copyright (c) 2014 Training. All rights reserved.
//

import UIKit
import MobileCoreServices

class MainViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SideBarDelegate {
    
    /* We will use this variable to determine if the viewDidAppear:
    method of our view controller is already called or not. If not, we will
    display the camera view */
    var beenHereBefore = false
    var controller: UIImagePickerController?
    
    @IBOutlet var imageView: UIImageView!
    
    var sideBar:SideBar = SideBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "image2")
        sideBar = SideBar(sourceView: self.view, menuItems: ["first item", "second item", "funny item", "another item"])
        sideBar.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePic(sender : AnyObject) {
        if beenHereBefore{
            /* Only display the picker once as the viewDidAppear: method gets
            called whenever the view of our view controller gets displayed */
            return;
        } else {
            beenHereBefore = true
        }
        
        if isCameraAvailable() && doesCameraSupportTakingPhotos(){
            
            controller = UIImagePickerController()
            
            if let theController = controller{
                theController.sourceType = .Camera
                
                theController.mediaTypes = [kUTTypeImage as NSString]
                
                theController.allowsEditing = true
                theController.delegate = self
                
                presentViewController(theController, animated: true, completion: nil)
            }
            
        } else {
            println("Camera is not available")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!){
            
            println("Picker returned successfully")
            
            let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
            
            if let type:AnyObject = mediaType{
                
                if type is String{
                    let stringType = type as String
                    
                    if stringType == kUTTypeMovie as NSString{
                        let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
                        if let url = urlOfVideo{
                            println("Video URL = \(url)")
                        }
                    }
                        
                    else if stringType == kUTTypeImage as NSString as NSString{
                        
                        let metadata = info[UIImagePickerControllerMediaMetadata]
                            as? NSDictionary
                        if let theMetaData = metadata{
                            let image = info[UIImagePickerControllerOriginalImage]
                                as? UIImage
                            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                            let destinationPath = documentsPath.stringByAppendingPathComponent("filename.jpg")
                            UIImageJPEGRepresentation(image,1.0).writeToFile(destinationPath, atomically: true)
                            
                            //                        let metadata = info[UIImagePickerControllerMediaMetadata]
                            //                            as? NSDictionary
                            //                        if let theMetaData = metadata{
                            //                            let image = info[UIImagePickerControllerOriginalImage]
                            //                                as? UIImage
                            //                            if let theImage = image{
                            //                                println("Image Metadata = \(theMetaData)")
                            //                                println("Image = \(theImage)")
                            //                            }
                        }
                    }
                    
                }
            }
            
            picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        println("Picker was cancelled")
        picker.dismissViewControllerAnimated(true, completion: nil)
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
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        if index == 0{
            imageView.backgroundColor = UIColor.redColor()
            imageView.image = nil
        } else if index == 1{
            imageView.backgroundColor = UIColor.clearColor()
            imageView.image = UIImage(named: "image2")
        }
    }
}

