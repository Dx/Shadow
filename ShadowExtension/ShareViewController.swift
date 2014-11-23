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
        return true
    }
    
    override func presentationAnimationDidFinish() {
        
        super.presentationAnimationDidFinish()
        
        placeholder = "Send to Shadow"
        
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
                            if let url = content as? NSURL{
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    var data = NSData(contentsOfURL: url)

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
        var error: NSError? = nil
        let fileManager = NSFileManager.defaultManager()
        
        let containerURL = fileManager.containerURLForSecurityApplicationGroupIdentifier("group.palmera.shadow")!.URLByAppendingPathComponent("ShadowMedia")
        
        let fileURL = containerURL.URLByAppendingPathComponent("file", isDirectory: false).URLByAppendingPathExtension("jpg")
        
        if fileManager.createDirectoryAtURL(containerURL, withIntermediateDirectories: true, attributes: nil, error:&error) {
            imageData?.writeToURL(fileURL, atomically: true)
        }
        
//        var result = fileManager.contentsOfDirectoryAtURL(containerURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.allZeros, error: &error)

        var result = fileManager.contentsOfDirectoryAtPath(containerURL.path!, error: &error)
        
        var foto = fileManager.contentsAtPath(fileURL.path!)
        
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
