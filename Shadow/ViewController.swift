//
//  ViewController.swift
//  extensionsample
//
//  Created by Dx on 07/10/14.
//  Copyright (c) 2014 Dx. All rights reserved.
//

import UIKit
import LocalAuthentication
import MobileCoreServices

class ViewController: UIViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Custom initialization
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create an alert
        var alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        // Add the cancel button to the alert
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        // Create the Local Authentication Context
        var touchIDContext = LAContext()
        var touchIDError : NSError?
        var reasonString = "Local Authentication Testing"
        
        // Check if we can access local device authentication
        if touchIDContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error:&touchIDError) {
            // Check what the authentication response was
            touchIDContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: {
                (success: Bool, error: NSError?) -> Void in
                // Check if we passed or failed
                if success {
                    // User authenticated using Local Device Authentication Successfully!
                    // self.performSegueWithIdentifier("openFirstVC", sender: self)
                    var containerVC = ContainerViewController.alloc()
                    self.presentViewController(containerVC, animated: false, completion: nil)
                    
                } else {
                    // Unsuccessful
                    
                    // Set the title of the unsuccessful alert
                    alert.title = "Unsuccessful!"
                    
                    // Set the message of the alert
                    switch error!.code {
                    case LAError.UserCancel.rawValue:
                        alert.message = "User Cancelled"
                    case LAError.AuthenticationFailed.rawValue:
                        alert.message = "Authentication Failed"
                    case LAError.PasscodeNotSet.rawValue:
                        alert.message = "Passcode Not Set"
                    case LAError.SystemCancel.rawValue:
                        alert.message = "System Cancelled"
                    case LAError.UserFallback.rawValue:
                        alert.message = "User chose to try a password"
                    default:
                        alert.message = "Unable to Authenticate!"
                    }
                    
                    // Show the alert
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        } else {
            // Set the error title
            alert.title = "Error"
            
            // Set the error alert message with more information
            switch touchIDError!.code {
            case LAError.TouchIDNotEnrolled.rawValue:
                alert.message = "Touch ID is not enrolled"
            case LAError.TouchIDNotAvailable.rawValue:
                alert.message = "Touch ID not available"
            case LAError.PasscodeNotSet.rawValue:
                alert.message = "Passcode has not been set"
            default:
                alert.message = "Local Authentication not available"
            }
            
            // Show the alert
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

