//
//  ShareViewController.swift
//  sharextensionsaple
//
//  Created by Dx on 08/10/14.
//  Copyright (c) 2014 Dx. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController, AudienceSelectionViewControllerDelegate {
    
    var imageData: NSData?
    
    override func isContentValid() -> Bool {
        if let data = imageData{
            if contentText.utf16Count > 0{
                return true
            }
        }
        
        return false
    }
    
    override func presentationAnimationDidFinish() {
        super.presentationAnimationDidFinish()
        
        placeholder = "Send to SecThis"
        
        let content = extensionContext?.inputItems[0] as NSExtensionItem
        let contentType = kUTTypeImage as NSString
        
        for attachment in content.attachments as [NSItemProvider]{
            if attachment.hasItemConformingToTypeIdentifier(contentType){
                
                let dispatchQueue =
                dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                
                dispatch_async(dispatchQueue, {[weak self] in
                    
                    let strongSelf = self!
                    
                    attachment.loadItemForTypeIdentifier(contentType,
                        options: nil,
                        completionHandler: {(content: NSSecureCoding!, error: NSError!) in
                            if let data = content as? NSData{
                                dispatch_async(dispatch_get_main_queue(), {
                                    strongSelf.imageData = data
                                    strongSelf.validateContent()
                                })
                            }
                    })
                    
                })
            }
            
            break
        }
        
    }
    
    
    
    override func didSelectPost() {
        
        let fileManager = NSFileManager()
        var documentsFolder = NSURL()
        
        let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as [NSURL]
        
        if urls.count > 0 {
            documentsFolder = urls[0]
            println("\(documentsFolder)")
        } else {
            println("Could not find the Documents folder")
        }
        
        imageData?.writeToURL(documentsFolder, atomically: true)
        
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }
    
    lazy var audienceConfigurationItem: SLComposeSheetConfigurationItem = {
        let item = SLComposeSheetConfigurationItem()
        item.title = "Folder"
        item.value = AudienceSelectionViewController.defaultAudience()
        item.tapHandler = self.showAudienceSelection
        return item
        }()
    
    override func configurationItems() -> [AnyObject]! {
        return [audienceConfigurationItem]
    }
    
    func showAudienceSelection(){
        let controller = AudienceSelectionViewController(style: .Plain)
        controller.audience = audienceConfigurationItem.value
        controller.delegate = self
        pushConfigurationViewController(controller)
    }
    
    func audienceSelectionViewController(sender: AudienceSelectionViewController,
        selectedValue: String) {
            audienceConfigurationItem.value = selectedValue
            popConfigurationViewController()
    }
    
}
